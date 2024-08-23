package com.synopsys.integration.detectable.detectables.opam.transform;

import com.synopsys.integration.bdio.graph.BasicDependencyGraph;
import com.synopsys.integration.bdio.graph.DependencyGraph;
import com.synopsys.integration.bdio.model.Forge;
import com.synopsys.integration.bdio.model.dependency.Dependency;
import com.synopsys.integration.bdio.model.externalid.ExternalId;
import com.synopsys.integration.bdio.model.externalid.ExternalIdFactory;
import com.synopsys.integration.detectable.ExecutableTarget;
import com.synopsys.integration.detectable.ExecutableUtils;
import com.synopsys.integration.detectable.detectable.codelocation.CodeLocation;
import com.synopsys.integration.detectable.detectable.executable.DetectableExecutableRunner;
import com.synopsys.integration.detectable.detectables.opam.parse.OpamFileParser;
import com.synopsys.integration.detectable.detectables.opam.parse.OpamParsedResult;
import com.synopsys.integration.executable.ExecutableOutput;
import com.synopsys.integration.executable.ExecutableRunnerException;

import java.io.File;

import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.Set;
import java.util.HashSet;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OpamGraphTransformer {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private static final String VERSION = "version";
    private static final String DEPENDS = "depends";
    private final File sourceDirectory;
    private final ExternalIdFactory externalIdFactory;
    private final DetectableExecutableRunner executableRunner;
    Map<Dependency, Set<Dependency>> visitedDependenciesGraph = new HashMap<>();
    public OpamGraphTransformer(File sourceDirectory, ExternalIdFactory externalIdFactory, DetectableExecutableRunner executableRunner) {
        this.sourceDirectory = sourceDirectory;
        this.externalIdFactory = externalIdFactory;
        this.executableRunner = executableRunner;
    }

    public CodeLocation transform(ExecutableTarget opamExe, OpamParsedResult opamParsedResult) throws ExecutableRunnerException {
        DependencyGraph dependencyGraph = new BasicDependencyGraph();

        if(opamExe != null) {
            for(String dependency: opamParsedResult.getParsedDirectDependencies()) {
                findTransitiveDependencies(dependency, opamExe, dependencyGraph, new OpamFileParser(), null); // recursively run opam show to get all dependencies
            }
            if(opamParsedResult.getProjectVersion().isEmpty() && !opamParsedResult.getProjectName().isEmpty()) {
                opamParsedResult.setProjectVersion(getProjectVersion(opamExe, opamParsedResult.getProjectName())); // if version is empty, try to find version with opam exe and project name
            }
        } else {
            addDirectDependenciesToGraph(opamParsedResult, dependencyGraph); // no transitive dependencies will be detected
            if(opamParsedResult.getProjectVersion().isEmpty()) {
                opamParsedResult.setProjectVersion(opamParsedResult.getProjectName());
            }
        }

        ExternalId projectId = createExternalId(opamParsedResult.getProjectName(), opamParsedResult.getProjectVersion()).getExternalId();

        return new CodeLocation(dependencyGraph, projectId, opamParsedResult.getSourceCode());
    }

    public String getProjectVersion(ExecutableTarget opamExe, String projectName) throws ExecutableRunnerException {
        List<String> arguments = new ArrayList<>();
        arguments.add("show");
        arguments.add(projectName);
        arguments.add("--field=version"); // command to get just version

        String version = "";

        //run opam show on project to get version
        ExecutableOutput executableOutput = executableRunner.execute(ExecutableUtils.createFromTarget(sourceDirectory, opamExe, arguments));

        if(executableOutput.getReturnCode() == 0) {
            List<String> output = executableOutput.getStandardOutputAsList();
            if(!output.isEmpty()) {
                return output.get(0); // parse the single line version output
            }
        } else {
            logger.warn("Did not get the version successfully, please include version in the opam file.");
            return projectName;
        }
        return version;
    }

    private void addDirectDependenciesToGraph(OpamParsedResult opamParsedResult, DependencyGraph dependencyGraph) {
        List<String> directDependencies = opamParsedResult.getParsedDirectDependencies();
        Map<String, String> opamLockDependencies = opamParsedResult.getLockFileDependencies();

        //match direct dependencies found in opam files with all the resolved packages from lock files to generate graph
        for(String dependency: opamLockDependencies.keySet()) {
            if(directDependencies.contains(dependency)) {
                String packageVersion = opamLockDependencies.get(dependency);
                Dependency directDependency = createExternalId(dependency, packageVersion); //convert to OPAM dependency
                dependencyGraph.addDirectDependency(directDependency); //add Dependency to root
            }
        }
    }

    private void findTransitiveDependencies(String dependency, ExecutableTarget opamExe, DependencyGraph dependencyGraph, OpamFileParser parser, Dependency parentDependency) throws ExecutableRunnerException {
        Optional<Dependency> visitedDependencyOptional = visitedDependenciesGraph.keySet().stream().filter(dep -> dep.getName().equals(dependency)).findFirst(); // check if the dependency is already been visited first
        if(visitedDependencyOptional.isPresent() && visitedDependenciesGraph.containsKey(visitedDependencyOptional.get())) {
            Dependency visitedDependency = visitedDependencyOptional.get();
            if(parentDependency == null) {
                dependencyGraph.addDirectDependency(visitedDependency);
            }
            dependencyGraph.addParentWithChildren(visitedDependency, visitedDependenciesGraph.get(visitedDependency)); // add child of that dependency in the graph
            addChildDependencies(dependencyGraph, visitedDependenciesGraph.get(visitedDependency)); // add child dependencies for all the transitives already visited in the graph to skip running show
        } else {
            List<String> output = runOpamShow(opamExe, dependency);

            if (output.isEmpty()) {
                return;
            }

            Map<String, String> parsedOutput = parser.parseData(output); // parse opam show output

            String version = parsedOutput.get(VERSION);

            Dependency createdDependency = createExternalId(dependency, version); // create dependency with name and version

            visitedDependenciesGraph.put(createdDependency, new HashSet<>()); // put dependency in graph

            if (parentDependency == null) {
                dependencyGraph.addDirectDependency(createdDependency);
            } else {
                dependencyGraph.addChildWithParent(createdDependency, parentDependency);
                visitedDependenciesGraph.get(parentDependency).add(createdDependency); // put current dependency as child of parent to memoize
            }

            //parse the chain of dependencies to get transitives
            if (parsedOutput.containsKey(DEPENDS)) {
                String[] dependentPackages = parsedOutput.get(DEPENDS).split(", ");
                for (String dependencyPackage : dependentPackages) {
                    findTransitiveDependencies(dependencyPackage, opamExe, dependencyGraph, parser, createdDependency);
                }
            }
        }
    }

    private List<String> runOpamShow(ExecutableTarget opamExe, String dependency) throws ExecutableRunnerException {
        List<String> arguments = new ArrayList<>();
        arguments.add("show");
        arguments.add(dependency);
        arguments.add("--raw"); // adding this will show the output as file.

        ExecutableOutput executableOutput = executableRunner.execute(ExecutableUtils.createFromTarget(sourceDirectory, opamExe, arguments));

        if(executableOutput.getReturnCode() == 0) {
            return executableOutput.getStandardOutputAsList();
        } else {
            throw new ExecutableRunnerException(new Exception("There was an error running opam show on the "+ dependency +" package. Please run opam install . and try running the scan again."));
        }
    }

    private Dependency createExternalId (String name, String version) {
        ExternalId externalId = externalIdFactory.createNameVersionExternalId(Forge.NPMJS, name, version);
        return new Dependency(externalId);
    }

    private void addChildDependencies(DependencyGraph dependencyGraph, Set<Dependency> setOfChildren) {
        for(Dependency childDependency: setOfChildren) {
            // recursively add visited child dependencies in the graph
            if(visitedDependenciesGraph.containsKey(childDependency) && !visitedDependenciesGraph.get(childDependency).isEmpty()) {
                dependencyGraph.addParentWithChildren(childDependency, visitedDependenciesGraph.get(childDependency));
                addChildDependencies(dependencyGraph, visitedDependenciesGraph.get(childDependency));
            }
        }
    }
}
