package com.synopsys.integration.detect.workflow.codelocation;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import com.synopsys.integration.bdio.graph.DependencyGraph;
import com.synopsys.integration.bdio.model.Forge;
import com.synopsys.integration.bdio.model.dependency.Dependency;
import com.synopsys.integration.bdio.model.externalid.ExternalId;
import com.synopsys.integration.detect.configuration.DetectConfiguration;
import com.synopsys.integration.detect.exception.DetectUserFriendlyException;
import com.synopsys.integration.detect.workflow.event.EventSystem;
import com.synopsys.integration.detect.workflow.file.DirectoryManager;
import com.synopsys.integration.util.NameVersion;

public class BdioCodeLocationCreatorTest {

    @Test
    public void testCreateFromDetectCodeLocations() throws IOException, DetectUserFriendlyException {

        final File sourceDir = new File("src/test/resource");

        final CodeLocationNameManager codeLocationNameManager = Mockito.mock(CodeLocationNameManager.class);
        final DetectConfiguration detectConfiguration = Mockito.mock(DetectConfiguration.class);
        final DirectoryManager directoryManager = Mockito.mock(DirectoryManager.class);
        Mockito.when(directoryManager.getSourceDirectory()).thenReturn(sourceDir);
        final EventSystem eventSystem = Mockito.mock(EventSystem.class);
        final BdioCodeLocationCreator creator = new BdioCodeLocationCreator(codeLocationNameManager, detectConfiguration, directoryManager, eventSystem);
        final NameVersion projectNameVersion = new NameVersion("testName", "testVersion");
        final DependencyGraph dependencyGraph = Mockito.mock(DependencyGraph.class);
        final Set<Dependency> dependencies = new HashSet<>();
        final Dependency dependency = Mockito.mock(Dependency.class);
        dependencies.add(dependency);
        Mockito.when(dependencyGraph.getRootDependencies()).thenReturn(dependencies);

        final ExternalId externalId = new ExternalId(Forge.MAVEN);
        externalId.name = "testExternalIdName";
        externalId.version = "testExternalIdVersion";
        externalId.architecture = "testExternalIdArch";
        final DetectCodeLocation detectCodeLocation = DetectCodeLocation.forCreator(dependencyGraph, sourceDir, externalId, "testCreator");
        final List<DetectCodeLocation> detectCodeLocations = new ArrayList<>();
        detectCodeLocations.add(detectCodeLocation);
        Mockito.when(codeLocationNameManager.createCodeLocationName(detectCodeLocation, sourceDir.getAbsolutePath(), projectNameVersion.getName(), projectNameVersion.getVersion(), null, null)).thenReturn("testCodeLocationName");

        final BdioCodeLocationResult result = creator.createFromDetectCodeLocations(detectCodeLocations, projectNameVersion);

        assertEquals("testCodeLocationName", result.getBdioCodeLocations().get(0).getCodeLocationName());
        final File resultDir = result.getBdioCodeLocations().get(0).getDetectCodeLocation().getSourcePath();
        assertTrue(resultDir.getCanonicalPath().contains("test"));
        assertTrue(resultDir.getCanonicalPath().contains("resource"));
    }
}
