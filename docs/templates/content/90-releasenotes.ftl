# Release notes

## Version 7.1.0

### New Features
* There now exist Docker images that can be used to run ${solution_name} from within a container.  See [Running ${solution_name} from within a Docker container](/30-running/#running-synopsys-detect-from-within-a-docker-container) for more details.

### Changed features

### Resolved issues
* (IDETECT-2541) Resolved an issue that caused the CLANG detector to fail when run in non-English locales on Ubuntu and Debian systems.

## Version 7.0.0
### New Features
* Added scripts detect7.sh and detect7.ps1 for invoking ${solution_name} 7.x.x. detect.sh and detect.ps1 will (by default) continue to invoke the latest ${solution_name} 6 version.
* Added support for Yarn workspaces.
* Added support for the dependency graph SBT plugin. Resolution cache generation is no longer a requirement of the SBT detector.
* Added the properties [detect.excluded.directories](../properties/configuration/paths/#detect-excluded-directories-advanced), [detect.excluded.directories.defaults.disabled](../properties/configuration/paths/#detect-excluded-directories-defaults-disabled-advanced), and [detect.excluded.directories.search.depth](../properties/configuration/signature scanner/#detect-excluded-directories-search-depth) to handle exclusions for detector search and signature scanning.
* Added ability to specify excluded directory paths using [glob patterns](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/nio/file/FileSystem.html#getPathMatcher(java.lang.String)).
* Added properties [detect.lerna.excluded.packages](../properties/detectors/lerna/#lerna-packages-excluded-advanced) and [detect.lerna.included.packages](../properties/detectors/lerna/#lerna-packages-included-advanced) to exclude and include specific Lerna packages.
* Added critical security risks to the Black Duck Risk Report pdf.
* Added detect.target.type to enhance the docker user experience. When set to IMAGE, some tools are automatically disabled and detect optimizes for an image based scan.
* Added binary scanning of the container filesystem to the default Docker image scanning workflow.
If you are scanning Docker images and your Black Duck server does not have the binary scanning feature enabled,
use --detect.tools.exluded=BINARY_SCAN to disable the binary scan step.

### Changed features
* The following directories will be excluded from signature scan by default, in addition to node_modules: bin, build, .git, .gradle, out, packages, target. Use [detect.excluded.directories.search.depth](../properties/configuration/signature scanner/#detect-excluded-directories-search-depth) to disable these defaults.
* Detect no longer supports the exclusion of individual files during detector search, only directories.
* Gradle detector no longer uses the gradle inspector. Only the init script is required.
* The default BDIO format for communicating dependency graphs to Black Duck has been changed from BDIO1 to BDIO2.
* Risk report generation will download fonts from Artifactory or use the font files in the fonts directory in the air gap zip of detect.

### Resolved issues
* (IDETECT-2462) Resolved an issue where projects were being inaccurately diagnosed as Poetry projects due to the presence of a pyproject.toml file.
* (IDETECT-2527) Resolved an issue in the Go Mod detector to extract and process data even if 'go mod why' command fails to run.
* (IDETECT-2434) Resolved an issue in the CLANG detector on Ubuntu and Debian systems that caused it to omit a package when that package had been installed on the system from multiple architectures.
* (IDETECT-2362) The CLANG detector now uses the KB preferred alias namespace feature for improved match accuracy.
* (IDETECT-2413) Resolved an issue to upgrade internal dependencies to support JDK 15.
* (IDETECT-2409) Resolved an issue to allow Gradle detector to support Gradle 6.8.
* (IDETECT-2099) Improved error reporting for exceptions that occur during a Detect run. For each exception, a Detect "issue" is written to the log and to the status.json file.
* (IDETECT-2516) Improved error reporting for the case where environment variable BDS_JAVA_HOME is set incorrectly.

## Version 6.9.1
### Resolved issues
* (IDETECT-2555) Resolved an issue that could cause Detect, when run against Black Duck 2020.10.0, to fail with a message similar to: "Cannot cast... to... VersionBomCodeLocationBomComputedNotificationUserView".

## Version 6.9.0
### New Features
* Added ability for detectors to explain why they applied. It will appear in the logs at info level and in the status.json.
* Added the property detect.binary.scan.search.depth to define the directory search depth for the binary scanner.
* The status.json file now features a list of the provided Detect property values.
* When Detect is not configured to connect to blackduck or run offline, a link to the Detect help is included in an error message.

### Changed features
* Added the timezone to the date format in the default log message format.
* Reverted deprecations for detect.blackduck.signature.scanner.arguments, detect.blackduck.signature.scanner.copyright.search, detect.blackduck.signature.scanner.dry.run, detect.blackduck.signature.scanner.individual.file.matching, detect.blackduck.signature.scanner.license.search, detect.blackduck.signature.scanner.local.path, detect.blackduck.signature.scanner.paths, detect.blackduck.signature.scanner.snippet.matching, detect.blackduck.signature.scanner.upload.source.mode.

### Resolved issues
* (IDETECT-1986) Resolved an issue where warnings regarding reflective access appear at the start of Detect.
* (IDETECT-2400) Resolved an issue where 'dependencies' would be removed from the value of the detect.gradle.build.command property.
* (IDETECT-2394) Resolved an issue that created inaccurate relationships in the BDIO files when Gemlock files were processed.
* (IDETECT-2404) Resolved an issue where signature scanner arguments passed through detect.blackduck.signature.scanner.arguments that contained space were being improperly parsed.
* (IDETECT-2525) Resolved an issue with the Yarn detector that caused component version information to be missing when the yarn.lock file contained quoted field keys.
* (IDETECT-2254) Resolved an issue with the Yarn detector that caused certain components to be omitted from some Yarn 2 projects.
* (IDETECT-2471) Resolved an issue where a missing Git executable in certain situations causes an exception.


## Version 6.8.0
### New features
* Added support for Conan projects that have the Conan revisions feature enabled.
* Added detect.pip.path for advanced users who wish to specify which pip executable to run.
* Improved the Pip Inspector to attempt to discover files named "requirements.txt" if no requirements files are specified through detect.pip.requirements.path.

### Changed features
* Added detect.timeout to consolidate the functionality of blackduck.timeout and detect.report.timeout.
* Added date of latest scan for a project version to the risk report pdf.
* Deprecated properties blackduck.timeout and detect.report.timeout. They have been consolidated into the new property detect.timeout.
* Deprecated all Detect exclusion properties. Future releases will feature a new property to extend and consolidate these properties.
* Deprecated all Detect signature scanner properties.  Future releases will feature an alternative mechanism for providing signature scanner arguments to Detect.
* Deprecated property detect.resolve.tilde.in.paths. Resolving tildes is a shell feature which Detect will no longer support in a future version.
* Deprecated property detect.python.python3. Due to the January 2020 sunset of Python 2, this property (which toggles between searching for a 'python' and 'python3' executable) is no longer necessary. See: [PEP-394](https://www.python.org/dev/peps/pep-0394/#recommendation)
* Deprecated properties detect.docker.inspector.air.gap.path, detect.gradle.inspector.air.gap.path, and detect.docker.inspector.air.gap.path as part of an effort to simplify Detect.
* Deprecated properties detect.default.project.version.scheme, detect.default.project.version.text, detect.default.project.version.timeformat as part of the effort to simplify Detect.
* Deprecated properties blackduck.username and blackduck.password. Authentication should be performed using an API token.

### Resolved issues
* (IDETECT-2216) Resolved an issue that prevented non-ASCII filenames from being correctly transmitted to Black Duck during a binary scan file upload.
* (IDETECT-2227) Resolved an issue where Nuget Inspectors would parse source files for assembly version.
* (IDETECT-2281) Resolved an issue that included golang dependencies that were not linked in the compiled go application. [241](https://github.com/blackducksoftware/synopsys-detect/issues/241)
* (IDETECT-2294) Resolved an issue where Git credentials could be logged when reading the remote url.
* (IDETECT-2296) Resolved an issue wherein the Pip Inspector would cease parsing a requirements file if it encountered a dependency which it could not resolve.
* (IDETECT-2276) Resolved an issue that caused the CLANG detector to omit components for which multiple architectures are installed.

## Version 6.7.0
### Resolved issues
* (IDETECT-2285) Resolved an issue that could cause Detect to fail to authenticate with Black Duck with the error message "No Bearer token found when authenticating.".
* (IDETECT-2221) Resolved an issue where the Docker Inspector logging level was not set correctly when property logging.level.detect was used.
* (IDETECT-2213) Resolved an issue that could cause the CLANG detector to omit some components on Debian-based Linux systems.
* (IDETECT-2284) Resolved an issue that could cause the CLANG detector to omit some components for projects using the clang/clang++ compiler when source files reference include files using non-canonical paths.
* (IDETECT-2216) Resolved an issue that caused non-ASCII characters in binary scan metadata (filename, code location name, project name, and version name) to be converted to '?' characters when submitted to Black Duck.
* (IDETECT-2291) Reverted replacement data support. Detect will report exactly what gradle reports. This reverts IDETECT-2038, IDETECT-2203.
* (IDETECT-2241) Resolved an issue where platform dependent cocoapods will throw an exception when they are not installed.
* (IDETECT-2289) Resolved an issue that could cause Black Duck API token-based authorization to fail with "411 Length Required" HTTP status when communicating with Black Duck through a proxy.

## Version 6.6.0
### Changed features
* The Docker Inspector now works on Windows 10 Enterprise.
* Upon connecting to Black Duck, the users roles and groups, which are only used in DEBUG-level logging, are no longer fetched unless logging level is DEBUG or higher.
* The error messages produced for binary scan file upload failures have been improved.
* The "detectors" field in the status.json file now features status data with more-expressive error codes derived from the runtime class of a detectable result.
* Detect will follow 308 redirects when communicating with Black Duck.

### Resolved issues
* (IDETECT-2038, IDETECT-2203) Resolved an issue where the Gradle Inspector would produce false positives in Gradle as a result of dependency replacement from the root project.
* (IDETECT-2180) Resolved and issue where the Pip Inspector would fail against requirements.txt files generated by the pip-compile tool.
* (IDETECT-2108) Resolved an issue where Lerna packages where being reported as missing dependencies.
* (IDETECT-2138, IDETECT-2161, IDETECT-2172) Resolved issue where Gradle parse detector would fail due to an inability to resolve classes, referenced in the project's build scripts, that were outside of Detect's classpath.
* (IDETECT-2110) Nuget inspectors will correctly return -1 when an error occurs by default.
* (IDETECT-2202) Impact analysis code locations will now appear in the status.json file.

### Known issues
* When running the Docker Inspector on Windows, ${solution_name} may fail to clean up all of its working directories (and log the message "Error trying cleanup") due to the following Docker issue: https://github.com/docker/for-win/issues/394.
* False positives from Gradle are still possible if the replacement dependency is defined within a subproject that has subprojects. Work is being continued to fix this with IDETECT-2218.

## Version 6.5.0
### New features
* Added [properties](../properties/configuration/debug/#diagnostic-mode) for enabling diagnostic mode.
* ${solution_name} now supports Vulnerability Impact Analysis. Enabled using [Vulnerability Impact Analysis Enabled](../properties/configuration/impact%20analysis/#vulnerability-impact-analysis-enabled) property.

### Changed features
* Enabling diagnostic mode is now controlled through two new properties.
* [--detect.diagnostic](../properties/configuration/debug/#diagnostic-mode)
* [--detect.diagnostic.extended](../properties/configuration/debug/#diagnostic-mode-extended)
* The *detect.bazel.dependency.type* property now accepts a comma-separated list of dependency types, or the value *NONE*, or the value *ALL*.

### Resolved issues
* (IDETECT-2054) Resolved an issue that caused the Gradle Inspector to fail when detect.output.path is set to a relative path.

## Version 6.4.2
### Resolved Issues
* (IDETECT-2164) Resolved an issue with scanning Go applications when using the go list -m command, which couldn't determine available upgrades using the vendor directory.

## Version 6.4.0
### New features
* Bazel detector: added support for Bazel projects that specify dependencies using the haskell_cabal_library repository rule.
* NuGet detector: added support for DotNet 3.1 runtime.
* ${solution_name} now supports projects managed by the Lerna package manager.
* ${solution_name} now supports projects managed by the Cargo package manager.
* ${solution_name} now supports projects managed by the Poetry package manager.

### Changed features
* Eliminated any need for the ${blackduck_product_name} Global Code Scanner overall role.
* The CLANG detector collects any dependency files not recognized by the Linux package manager that reside outside the source directory (the directory containing the compile_commands.json file),
and writes them to the status.json file.
* Added the property [detect.blackduck.signature.scanner.copyright.search](../properties/configuration/signature scanner/#signature-scanner-copyright-search-advanced).
* Removed PipEnv from the list of buildless detectors as it was never buildless.
* Improved output for signature scanner status, and included descriptions for exit codes when reporting overall status.
* Status.json file now collects code location data generated by all tools, not just detectors.
* Status.json file now collects issue data generated by all tools.

### Resolved issues
* (IDETECT-2019) Resolved an issue where the pip inspector would not be able to parse the requirements.txt file if pip's version was >= 20.1.
* (IDETECT-2034) Resolved an issue that would cause a NullPointerException when ${solution_name}'s initial attempt at generating a code location name produced a code location name greater than 250 characters and either code location prefix or code location suffix is not set.
* (IDETECT-1979) Resolved an issue that could cause the CLANG detector to miss some dependencies because it failed to correctly parse complex nested quoted strings within compile_commands.json values.
* (IDETECT-1966) Resolved an issue that would cause Detect to ignore replacement directives for Go Mod projects.

### Known Issues
* When a Lerna package depends on another Lerna package within the project, an error may appear indicating a missing dependency on that package. This is normal and no dependencies are missing. This will be fixed in a future release.

## Version 6.3.0
### New features
* The Yarn detector now extracts project information from package.json files. Git is no longer the default supplier of project information for Yarn projects.
* Added Yarn Detector support for dependencies that are missing a fuzzy version in a lockfile dependency declaration.
* ${solution_name} logs policy violations when it is configured to [fail on policy violations](../properties/configuration/project/#fail-on-policy-violation-severities).

### Changed features
* Users can [upload source](../properties/configuration/signature scanner/#upload-source-mode) files when [license search](../properties/configuration/signature scanner/#signature-scanner-license-search) is enabled regardless of whether [snippet matching](../properties/configuration/signature scanner/#snippet-matching) has been enabled.
* ${solution_name} is now compatible with Yocto 3.0.
* ${solution_name} stops if the Docker Inspector tool applies and ${solution_name} is running on Windows.
* ${solution_name} configures Docker Inspector's working directories inside ${solution_name}'s run directory.
* ${solution_name} requires and runs Docker Inspector version 9.
* Moved the location to which ${bash_script_name} downloads the ${solution_name} .jar from /tmp to ~/synopsys-detect/download.

### Resolved issues
* (IDETECT-1906) Resolved an issue wherein git extraction might fail if "git log" returned unexpected output.  As a last resort, the commit hash will be used as a version.
* (IDETECT-1883) Resolved an issue where ${solution_name} failed to extract project information when parsing a Git repository with a detached head while in buildless mode.
* (IDETECT-1970) Resolved an issue where the default value for [parallel processors](../properties/configuration/general/#detect-parallel-processors-advanced) was not used. The available runtime processor count was being used instead.
* (IDETECT-1973) Resolved an issue where the NuGet exe inspector would not resolve from Artifactory.
* (IDETECT-1965) Resolved an issue where ${solution_name} would fail to resolve environment variables where it did so previously.
* (IDETECT-1974) Resolved an issue wherein the Yarn detector was throwing an exception for dependencies not defined in the yarn.lock file.
* (IDETECT-2037) Resolved an issue where ${solution_name} would fail with a "hostname in certificate didn't match" error while downloading the Gradle inspector.

## Version 6.2.1
### Resolved issues
* Resolved an issue wherein an exception was thrown when generating a risk report if users didn't set the risk report output path explicitly. (IDETECT-1960)

## Version 6.2.0
### New features
* The ${solution_name} .jar file is now signed, enabling [code verification](../advanced/verifying/) by users.
* [Simple proxy information](../advanced/package-managers/gradle/#running-the-gradle-inspector-with-a-proxy) will be forwarded to the Gradle Inspector.
* Detect now creates a status file describing the results of the run which includes things like [issues, results and status codes.](../advanced/status-file/)
* The property configuration table in the log now includes the origin of the property's value.
* Added the property [detect.blackduck.signature.scanner.license.search](../properties/configuration/signature scanner/#signature-scanner-license-search-advanced).
* Added the property [detect.blackduck.signature.scanner.individual.file.matching](../properties/configuration/signature scanner/#individual-file-matching-advanced).
* If an executable returns a nonzero exit code, Detect will now log the executable output automatically.
* Added page for [deprecated properties](../properties/deprecated-properties/) in help.
* Detect-generated risk reports now feature Synopsys logo and branding.

### Changed features
* The [PipEnv Detector](../advanced/package-managers/python/#pipenv-detector) now parses a json representation of the dependency tree.
* Powershell download speed increased.

### Resolved issues
* Resolved an issue where the download URL for ${solution_name} was being set to an internal URL upon release (IDETECT-1847).
* Resolved an issue where all transitive dependencies found by the [Pip inspector](../advanced/package-managers/python/#the-pip-detector) were being reported as direct dependencies (IDETECT-1893).
* Resolved an issue where using pip version 20+ with the [Pip inspector](../advanced/package-managers/python/#the-pip-detector) caused a failure to import a dependency. [GitHub PR](https://github.com/blackducksoftware/synopsys-detect/pull/107) (IDETECT-1868)
* Resolved the following vulnerabilities (IDETECT-1872):
* org.springframework.boot:spring-boot-starter 5.1.7.RELEASE BDSA-2020-0069 (CVE-2020-5398)
* Resolved an issue where ${solution_name} had the potential to fail on projects that utilized Yarn workspaces (IDETECT-1916).
* Note: Yarn workspaces are not currently supported. See [yarn workspace support](../advanced/package-managers/yarn/#yarn-workspace-support).
* Resolved an issue in the Bazel Detector that caused it to fail for the maven_install rule when the tags field contained multiple tags with a mixture of formats (IDETECT-1925).
* When parsing package.xml files, Detect will no longer raise a SAXParseException when the file contains a doctype declaration, and will continue parsing the rest of the file (IDETECT-1866).
* Resolved an issue that could cause generation of an invalid Black Duck Input/Output (BDIO) file when the only differences between two component names/versions are non-alphanumeric characters (IDETECT-1856).

## Version 6.1.0
### New features
* Added the property [detect.bdio2.enabled](../properties/configuration/paths/#bdio-2-enabled).
* Added the property [detect.pip.only.project.tree](../properties/detectors/pip/#pip-include-only-project-tree).
* Added the property [detect.bitbake.search.depth](../properties/detectors/bitbake/#bitbake-search-depth).
* Added the property [detect.bazel.cquery.options](../properties/detectors/bazel/#bazel-cquery-additional-options).
* Added the property [detect.docker.image.id](../properties/detectors/docker/#docker-image-id).
* Added the property [detect.docker.platform.top.layer.id](../properties/detectors/docker/#platform-top-layer-id-advanced).
* Added the property [detect.bom.aggregate.remediation.mode](../properties/configuration/project/#bdio-aggregate-remediation-mode-advanced)

### Changed features
* Deprecated all ${polaris_product_name}-related properties.
* Added [wildcard support](../advanced/includeexcludewildcards/) for several include/exclude list properties.
* Improved the structure of the dependency information produced by the Yarn detector by changing its approach. It now parses dependency information from yarn.lock and package.json, instead of running the yarn command. Since the yarn command is no longer executed, the detect.yarn.path property has been removed.
* Improved match accuracy for Bitbake projects by improving external ID generation for dependencies referenced using Git protocols, and dependencies referenced with an epoch and/or revision.
* Improved the reliability of the Bitbake detector by generating recipe-depends.dot and package-depends.dot files the source directory, instead of a temporary directory.
* Changed the logging level of ${polaris_product_name} CLI output from DEBUG to INFO.
* Added support for the Noto-CJK font (for Chinese, Japanese, and Korean text) in the risk report.

### Resolved issues
* Resolved an issue that can cause a Null Pointer Exception on Maven projects configured for multi-threaded builds.
* Resolved an issue that can cause Detect to fail due to an expired Black Duck bearer token.
* Resolved an issue that causes Detect to fail when a parent project and version are specified, and the project is already a child of the specified parent.
* Resolved an issue that causes Detect to log the git username and password when a git command executed by Detect fails.
* Resolved an issue that can cause Detect to generate a new code location (scan) when the character case of the value of the detect.source.path property differs from a previous run on the same project.
* Resolved the following vulnerabilities: commons-beanutils:commons-beanutils 1.9.3 / BDSA-2014-0129 (CVE-2019-10086), org.apache.commons:commons-compress 1.18 / BDSA-2019-2725 (CVE-2019-12402)

## Version 6.0.0
### New features
* Added the property detect.binary.scan.file.name.patterns.
* Added the property detect.detector.search.exclusion.files which accepts a comma-separated list of file names to exclude from the Detector search.
* Custom arguments for the source command can now be supplied to Detect through the property detect.bitbake.source.arguments which accepts a comma-separated list of arguments. (1614)
* Added support for the Swift package manager.
* Added support for GoGradle.
* Added support for Go Modules.
* The property detect.pip.requirements.path is now a comma-separated list of paths to requirements.txt files. This enables you to specify multiple requirements files. Each requirements file displays as a new code location in Black Duck.
* Detect now logs username, roles, and groups for the current user.
* Detect now includes the project name/version in every code location name.
* Detect now takes in a go path, but does not take in go.dep.path; nor does Detect trigger on *.go.
* The property detect.parallel.processors is added. This property controls the number of parallel threads, and replaces the properties detect.blackduck.signature.scanner.parallel.processors and detect.hub.signature.scanner.parallel.processors.
* Added the property detect.maven.included.scopes. This is a comma-separated list of Maven scopes. Output is limited to dependencies within these scopes, and is overridden by exclude.
* Added the property detect.maven.excluded.scopes. This is a comma-separated list of Maven scopes. Output is limited to dependencies outside these scopes, and is overridden by include.
* Bazel detector: added support for dependencies specified using the maven_install workspace rule.  The detect.bazel.advanced.rules.path property is removed.
* When using Detect for static analysis, you can pass the build command to let the Polaris CLI know how to analyze a given project.

### Changed features

* Architecture is no longer included in BitBake dependencies discovered by Detect. The property detect.bitbake.reference.impl is no longer used and is deprecated.
* The BitBake detector no longer uses the property detect.bitbake.reference.impl because architecture is no longer required to match with artifacts in the KnowledgeBase. The Bitbake detector now attempts to determine the layer in which a component originated instead of the architecture.
* Improved the Detect on-screen logging to be more concise.
* The PiP inspector is no longer deprecated, and is currently supported.
* When creating an air gap zip of Detect using the switch -z or --zip, the created zip file is now published to your output directory.
* Scripts no longer fail if the Artifactory server is unavailable.
* Enhanced placement and formatting of deprecation logs.
* Added support for Java version 11.
* The following properties are removed in Detect version 6.0.0:
* detect.go.dep.path
* detect.npm.node.path
* detect.perl.path
* detect.go.run.dep.init
* detect.maven.scope
* detect.bazel.advanced.rules.path

### Resolved issues

* Resolved an issue wherein the Windows Java path construction did not account for direction of the slash. The shell script now uses the correct slash direction, based on the operating system on which Detect is running.
* Resolved an issue wherein Detect was not finding the file recipe-depends.dot written to the current directory. Detect now looks in the source directory to a depth of 1 if it cannot find the expected files in the expected location.
* Resolved an issue wherein Detect was failing if it could not resolve placeholders.
* Resolved an issue wherein Detect was not handling SSH URLs, which caused Detect to fail in extracting project information from the Git executable. GitCliDetectable now properly handles SSH URLs.
* Resolved an issue wherein the Detect JAR was downloading for each scan when the script could not communicate with Artifactory. Now, if the script cannot communicate with Artifactory, and there is an existing downloaded Detect, then the previously-downloaded version of Detect runs. However, if you provided a DETECT_LATEST_RELEASE_VERSION and Detect cannot communicate with Artifactory, Detect will not run.
* Resolved an issue wherein Detect was not properly parsing GIT URLs such as git://git.yoctoproject.org/poky.git.

## Version 5.6.2

### Resolved issues

* Synopsys Detect version 5.6.2 is a rebuild of version 5.6.0 and 5.6.1 to address an issue with the binary repository to which it was published.

## Version 5.6.0

### New features

* You can now set custom fields on created Black Duck projects.
* Detect can now generate its own air gap zip.
* Detectors now nest by default.
* Added support for Gradle Kotlin.
* Added support for wildcard (*) in the Detect flag blackduck.proxy.ignored.hosts.
* Added support for --detect.project.tags.
* Added the properties --detect.parent.project.name and --detect.parent.project.version.name.
* Added the property  --detect.clone.project.version.latest=true which takes precedence over the exact version name.
* Added support for Yocto 2.0.0.
* Added support to parse components from the &lt;plugins&gt; block in pom.xml. This only works when detect.detector.buildless=true.
* Added capability to represent '' and "" as a null value in Detect multiselect custom fields.

### Changed features

* You can now specify the search depth for buildless mode.
* Updated the help menu and provided more detailed help options.
* Diagnostics now includes signature scanner log files.
* Re-enabled empty aggregate file generation.
* Polaris no longer runs the the -w switch enabled by default.  To retrieve the issue/policy count, you can use the -w switch.
* Match accuracy for Docker images is improved by running the signature scanner on a squashed version of the Docker image instead of the container file system. This results in a different name for the code location because the name of the file being scanned is different. For existing projects, the old code location named by default as &lt;repo&gt;_&lt;tag&gt;_containerfilesystem.tar.gz/&lt;repo&gt;/&lt;tag&gt; scan must be removed to ensure it does not contribute stale data to the BOM. Due to the new method of scanning, the code location name has changed.  You must remove the old code location in favor of the new code location.

### Resolved issues

* Resolved an issue that could cause code location names to contain relative file paths when the value of detect.source.path uses symbolic links to specify the source directory.
* Resolved an issue that caused detect.sh to fail when Java is not on the system path, and the JAVA_HOME path contains a space.
* Resolved an issue wherein the signature scanner may not have been reporting failures correctly.
* Resolved an issue wherein Detect was not locating the file recipe-depends.dot when it was written to the current directory. Detect now searches for the recipe-depends.dot file to a depth of 1 when extracting on a BitBake project.
* Detect no longer fails if the Git executable is not found.
* Resolved an issue wherein Detect may fail when the directory pointed to by --detect.notices.report.path does not exist.

## Version 5.5.1

### Resolved issues

* Resolved an issue wherein the Pipenv detector was omitting project dependencies.

## Version 5.5.0

### New features

* Added support for snippet modes.
* The property detect.wait.for.results is been added to wait for Black Duck.  The default value is false.  If this property is set to true, Detect won't complete until the normal timeout is reached or the underlying systems with which Detect is communicating are once again idle and ready to receive more data.  The timeout value is controlled by blackduck.timeout.
* The shell script and PowerShell script now accept DETECT_JAVA_PATH and DETECT_JAVA_HOME as environment variables for pointing to your Java installation.
* Added a new property --detect.detector.search.exclusion.paths.  A comma-separated list of directory paths to exclude from a detector search. For example, foo/bar/biz only excludes the biz directory if the parent directory structure is 'foo/bar/'.
* Detect now uses Git information to determine the default project and version names.
* There is a new Detect property for overriding the Git executable: detect.git.path.

### Resolved issues


* Resolved an issue that caused the risk report to be generated with invalid links to Black Duck components.
* Resolved an issue that caused a null pointer exception error when a golang's Gopkg.lock file contained zero projects.
* Resolved an issue wherein the Clang detector could omit the epoch from the version string in RPM packages.
* Resolved an issue wherein with two users running Detect on a single system may result in a Permission denied error.
* Resolved an issue wherein the property -detect.policy.check.fail.on.severities may not be waiting for the snippet scans to complete.
* Resolved an issue wherein the property --detect.blackduck.signature.scanner.exclusion.name.patterns may not be following the paths.
* Resolved an issue wherein Detect may fail when the directory specified by --detect.risk.report.pdf.path did not exist.  Detect now attempts to create the directory structure to the specified path. A warning is logged if Detect fails to create the directory.
* Resolved an issue wherein properties that had a primary group and additional property group may have been excluded from the group search.
* Resolved an issue wherein the deprecation warning displayed when the deprecated property was provided by the user.
* Resolved an issue with aggregate BOM filename generation that could cause the message Unable to relativize path, full source path will be used to display in the log.
* Resolved an issue that could cause components to be omitted from the BOM for Conda projects.
* Resolved an issue that could cause errors during parsing of Maven projects with long sub-project names.

### Changed features

* The default value for the property detect.docker.path.required is now false.
* The ALL logging level is replaced with the TRACE logging level.
* The results URL for the Black Duck project BOM is now moved to the Detect Results panel.
* Renamed Detect Results to Detect Status.
* Previously, a temp file remained which could contain plain-text user name or password information.  This temp file is now removed.
* Bazel is added as an acceptable value to the detect.tools properties.
* Detect now uses the current version of Docker Inspector.  This means that no matter what version of Docker Inspector is currently released, Detect now uses that version.

## Version 5.4.0

### New features

* Added buildless mode.
* Added a new property for BitBake to remove Yocto reference implementation characters.
* Added a new property for adding group names to projects.
* Added a new property for uploading source files.
* Added the additional_components placeholder.

### Resolved issues

* Resolved an issue wherein Yarn may have been incorrectly calculating the tree level.
* Resolved an issue wherein Detect may fail when Polaris is excluded, a Polaris URL is provided, and connection to Polaris failed.
* Resolved an issue that caused Detect to follow symbolic links while searching directories for files.
* Resolved an issue wherein Detect was not failing policy for UNSPECIFIED when fail on severities is set to ALL.
* Resolved an issue that could cause a counter (an integer intended to ensure uniqueness), to be unnecessarily appended to a code location name.
* Resolved an issue that may have caused the package manager name to be excluded from the code location name when a code location name was provided.
* Resolved an issue that could cause Detect to continue after a Polaris connection failure.
* Resolved an issue wherein the Detect scan results may incorrectly show development dependencies.
* Resolved an issue that could cause reports to fail due to timeout intermittently.
* Resolved an issue that could cause the value of --polaris.access.token to be logged to the console when detect.sh is invoked.
* Resolved an issue wherein Detect was cleaning up the contents but not the directory of the run.

### Changed features

* For getting all logs, the ALL logging level is now TRACE.
* Improved the error message logged when the property detect.binary.scan.file.path, which must point to a readable file, points to something other than a readable file, such as a directory.
* Changed the environment variable used to tell the Detect scripts where to download the Detect jar.  The previous value DETECT_JAR_PATH is now changed to DETECT_JAR_DOWNLOAD_DIR.
* Improved the parsing of packrat.lock files to better represent the relationships between dependencies in the graph.
* The version of Detect is no longer part of the code location name.

## Version 5.3.3

* Resolved an issue wherein reports for projects containing risks may be generated with a status of zero risks shown.

## Version 5.3.2

* Synopsys Detect version 5.3.2 is a minor maintenance release.

## Version 5.3.1

### New features

* Added new property detect.ignore.connection.failures which enables Synopsys Detect to continue even if it fails to talk to Black Duck.

### Resolved issues

* Resolved an issue wherein build scan failures may occur in TFS with the error [COPY Operation] noSuchPath in source, path provided: //license/ownership.
* Resolved an issue wherein if the property detect.clone.project.version.name is set to a non-existent project version, the log messages are now improved to make it easier to recognize the problem.

### Changed features

* In cases where the property detect.clone.project.version.name is set to a non-existent project version, the log messages are now improved to make it easier to recognize the issue.

## Version 5.2.0

### New features

* Added support for Bazel.
* Added support for CMake.
* Added a property to support using project version nicknames.
* Added a property for application ID.
* Added Java wildcard pattern support.
* Added support for Coverity on Polaris.

### Resolved issues

* Resolved an issue wherein the package-lock.json file may be missing additional versions.
* Resolved an issue wherein multiple simultaneous Detect executions may cause BDIO merges.
* Resolved an issue wherein permission errors may display when creating projects or scanning.

### Changed features

* The --detect.bom.aggregate.name property now checks for an empty BOM.  If the BOM is empty, it is not uploaded to Black Duck.
* Added support for PiP versions 6.0.0 and higher.
* Improved error messages for Black Duck connection issues.
* Cosmetic changes: from Black Duck Detect to Synopsys Detect.
* Streamlined execution of Coverity and Black Duck scans through a single continuous integration job.
* Updated location of the shell/PowerShell scripts.
* Updated location of the air-gapped archive.

## Version 5.1.0

### New features

* Added support for GoVendor.
* Added executable output to diagnostic mode.
* Added the project/version GUID in the console output.
* Added error codes.

### Resolved issues

* Resolved an issue that fixes the Clang Detector (for C/C++) handling of complex quoted strings occurring in compiler commands found in the JSON compilation database (compile_commands.json) file.
* Resolved an issue wherein a Null Pointer Exception error may occur when Detect cannot access a file during signature scan exclusion calculating.
* Resolved an issue wherein the RubyGems package manager had missing components.
* Resolved an issue wherein the NPM package lock added every dependency as a root dependency.

### Changed features

* The properties --detect.nuget.path and --detect.nuget.inspector.name are deprecated.
* The properties detect.suppress.results.output and detect.suppress.configuration.output are deprecated.  The output from these properties is logged instead of written to sysout.
* Improved the reporting of scan registration limit errors.

## Version 5.0.1

### Resolved issues

* Resolved an issue wherein a null pointer exception error may occur in the NuGet portion of a scan when running Synopsys Detect in Linux.
* Resolved an issue that fixes the Clang Detector (for C/C++) handling of complex quoted strings occurring in compiler commands found in the JSON compilation database (compile_commands.json) file.
* Resolved an issue wherein using detect.tools=ALL did not run any tools.
* Resolved an issue wherein Coverity on Polaris may return a failure status for a successful upload.

### Changed features

* NuGet air gap mode now points to other folders.
* Removed support for PiP resolving the project version.

## Version 5.0.0

### New features

* Added a new property to execute Black Duck Docker Inspector.
* CocoaPods are now nestable under Bill of Materials (BOM) tools.
* Added functionality to exclude all BOM tools.
* Added a new property which enables you to search at a determined depth.
* Added functionality to log all found executables.
* Added functionality to run in Docker mode.
* Added support for NuGet in MacOS.
* Added ability to include and exclude all tools.
* Added a new properties for SWIP in Detect scans.

### Resolved issues

* Resolved an issue that caused the Gradle inspector to retrieve the maven-metadata.xml file from the default repository, even when the property detect.gradle.inspector.repository.url was set to point to a different repository.
* Resolved an issue wherein Gradle may upload older BDIO files into the current project.

### Changed features

* Improved C/C++ multi-threading functionality.
* Deprecated Pipenv inspector messages are now logged.
* The term BOM_TOOL is now replaced with DETECTOR.
* You can no longer supply ranges for the Inspector versions.
* Enhanced the code location naming conventions.
