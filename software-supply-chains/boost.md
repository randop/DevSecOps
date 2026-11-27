# **Boost C++: CVEs, Security Audits, and Cybersecurity Practices**

**Date: November 27, 2026**

## **1. Overview**

Boost C++ is an open-source collection of C++ libraries providing functionality for networking, file handling, data processing, serialization, cryptography-related operations, memory management, and other software development requirements.

Boost is not a single software application. It consists of approximately 150 libraries, many of which have independent maintainers, development cycles, and release schedules.

Consequently, security vulnerabilities and their severity depend on the specific Boost library, version, implementation, and how the library is used by an application.

## **2. Known CVEs affecting Boost C++**

The following table identifies documented vulnerabilities associated with Boost libraries.

### **2.1 Recently published CVEs (2026)**

| CVE ID                                                                                     | Affected component | Affected versions | Vulnerability                                                                                         | CVSS severity                        |
| ------------------------------------------------------------------------------------------ | ------------------ | ----------------- | ----------------------------------------------------------------------------------------------------- | ------------------------------------ |
| [CVE-2026-136911](https://nvd.nist.gov/vuln/detail/CVE-2026-136911?utm_source=chatgpt.com) | Boost.JSON         | 1.75.0–1.92.0     | Denial of service caused by uncontrolled memory allocation growth in `monotonic_resource::release()`  | 5.9 Medium (v3.1); 8.2 High (v4.0)   |
| [CVE-2026-137071](https://nvd.nist.gov/vuln/detail/CVE-2026-137071?utm_source=chatgpt.com) | Boost.JSON         | 1.84.0–1.92.0     | Information exposure due to retained parser state when reusing `parser_for` objects through `reset()` | 4.8 Medium (v3.1); 6.3 Medium (v4.0) |

**CVE-2026-136911 – Denial of Service**

The vulnerability involves `monotonic_resource::release()`, which does not properly reset its internal `next_size_` value when returning allocated memory blocks.

Repeated parsing operations can cause subsequent memory allocation requests to grow geometrically until allocations fail with `std::bad_alloc`.

This can result in denial of service when an application repeatedly processes JSON documents using the affected memory resource.

The proposed correction is tracked in [Boost.JSON PR #1227](https://github.com/boostorg/json/pull/1227?utm_source=chatgpt.com), which was merged into the development branch on November 26, 2026. This does not establish that a corrected stable release has been published.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://www.tenable.com\&sz=32)

Tenable®+2



**CVE-2026-137071 – Information Exposure**

The vulnerability affects `parser_for::reset()` in Boost.JSON.

When a parser is reused, nested parsing handlers can retain state from a previous document. Under certain parsing conditions, partial string data from an earlier document can appear in the result of a subsequent document.

This can expose previously processed data across parsing operations.

The issue is tracked in [Boost.JSON PR #1226](https://github.com/boostorg/json/pull/1226?utm_source=chatgpt.com), which remained open on November 27, 2026.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://www.tenable.com\&sz=32)

Tenable®+2



### **2.2 Historical CVEs**

| CVE ID                                                                                  | Affected component | Affected versions     | Vulnerability                                                        | Security impact                                       |
| --------------------------------------------------------------------------------------- | ------------------ | --------------------- | -------------------------------------------------------------------- | ----------------------------------------------------- |
| [CVE-2013-0252](https://nvd.nist.gov/vuln/detail/CVE-2013-0252?utm_source=chatgpt.com)  | Boost.Locale       | 1.48–1.52             | Improper validation of certain invalid UTF-8 sequences               | Input validation bypass                               |
| [CVE-2012-2677](https://www.cve.org/CVERecord?id=CVE-2012-2677\&utm_source=chatgpt.com) | Boost.Pool         | Boost Pool before 3.9 | Integer overflow in `ordered_malloc()`                               | Potential memory under-allocation and buffer overflow |
| [CVE-2008-0171](https://nvd.nist.gov/vuln/detail/CVE-2008-0171?utm_source=chatgpt.com)  | Boost.Regex        | 1.33 and 1.34         | Assertion failure when processing invalid regular expressions        | Denial of service                                     |
| [CVE-2008-0172](https://nvd.nist.gov/vuln/detail/CVE-2008-0172?utm_source=chatgpt.com)  | Boost.Regex        | 1.33 and 1.34         | NULL pointer dereference when processing invalid regular expressions | Denial of service                                     |

Sources: National Vulnerability Database, CVE records, and vendor security advisories.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://nvd.nist.gov\&sz=32)

nvd.nist.gov+4



**Additional CVE classification note**

CVE-2026-11460 has been associated with Boost.Serialization in some vulnerability databases. However, the Debian Security Tracker explicitly classifies this assignment as bogus. It should not be treated as a confirmed Boost vulnerability without further authoritative validation.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://security-tracker.debian.org\&sz=32)

security-tracker.debian.org+2



CVE-2016-9840 is also sometimes associated with Boost in vulnerability searches, but the underlying vulnerability is in zlib rather than Boost's own implementation.

## **3. Independent Security Audits of Boost C++**

### **3.1 Shielder Security Audit (2023–2024)**

Completed May 22, 2024

The Open Source Technology Improvement Fund (OSTIF), with support from Amazon Web Services (AWS), commissioned Shielder to conduct an independent security audit of Boost C++.

The audit examined the overall security posture of Boost and performed detailed source-code security testing on selected libraries.

**Audit details**

| Item                    | Details                                                             |
| ----------------------- | ------------------------------------------------------------------- |
| Security auditor        | Shielder                                                            |
| Sponsoring organization | Amazon Web Services                                                 |
| Audit facilitator       | OSTIF                                                               |
| Audit report date       | May 22, 2024                                                        |
| Audited version         | Boost 1.83.0                                                        |
| Audit team              | Three security engineers                                            |
| Audit effort            | Four person-weeks                                                   |
| Assessment type         | Source-code security assessment, dynamic analysis, and fuzz testing |

The audit primarily covered Boost 1.83.0, released on August 11, 2023. The differences introduced in Boost 1.84.0 were also examined to determine whether identified findings affected the subsequent release.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://ostif.org\&sz=32)

Boost+1



### **3.2 Libraries included in the audit**

Twelve Boost libraries were included:

| No. | Boost library         | Primary functionality                  |
| --- | --------------------- | -------------------------------------- |
| 1   | Boost.Beast           | HTTP and WebSocket networking          |
| 2   | Boost.DLL             | Dynamic library loading                |
| 3   | Boost.Date_Time       | Date and time processing               |
| 4   | Boost.Filesystem      | File and directory operations          |
| 5   | Boost.GIL             | Generic image processing               |
| 6   | Boost.Graph           | Graph data structures and algorithms   |
| 7   | Boost.JSON            | JSON parsing and serialization         |
| 8   | Boost.Program_Options | Command-line and configuration parsing |
| 9   | Boost.Regex           | Regular expression processing          |
| 10  | Boost.String_Algo     | String manipulation                    |
| 11  | Boost.URL             | URL parsing and manipulation           |
| 12  | Boost.UUID            | UUID generation and handling           |

[image](https://www.google.com/s2/favicons?domain=https://ostif.org\&sz=32)

Boost+1

### **3.3 Security testing methodology**

Shielder used multiple security testing techniques to identify vulnerabilities in the selected libraries.

| Testing technique                          | Tools and technologies           | Purpose                                                         |
| ------------------------------------------ | -------------------------------- | --------------------------------------------------------------- |
| Static application security testing (SAST) | CodeQL, Semgrep                  | Identify potentially vulnerable source-code patterns            |
| Fuzz testing                               | AFL++, OSS-Fuzz, ClusterFuzzLite | Test libraries against malformed, unexpected, and random inputs |
| Dynamic analysis                           | AddressSanitizer (ASan)          | Detect memory corruption and memory-safety problems             |
| Manual source-code analysis                | Security engineering analysis    | Examine sensitive implementation areas and input-handling logic |
| Automated testing                          | C++ security rules and queries   | Identify potential programming errors and insecure patterns     |

The testing focused particularly on memory safety, complex parsing functionality, input validation, and recursive operations.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://ostif.org\&sz=32)

Boost+1



### **3.4 Security audit results**

# **7**

**Security findings**

Identified vulnerabilities and issues

# **15**

**New fuzzing harnesses**

Developed and added to OSS-Fuzz

# **4**

**Closed findings**

Reported as remediated

# **3**

**Open findings**

At publication of the audit report

The seven findings were classified as follows:

| Severity      | Number of findings |
| ------------- | ------------------ |
| Critical      | 0                  |
| High          | 0                  |
| Medium        | 1                  |
| Low           | 4                  |
| Informational | 2                  |
| **Total**     | **7**              |

The report recorded four closed findings and three open findings as of May 22, 2024.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://ostif.org\&sz=32)

ostif.org+1



### **3.5 Detailed security findings**

| Library     | Finding                                                                                               | Severity      | Status in May 2024 report |
| ----------- | ----------------------------------------------------------------------------------------------------- | ------------- | ------------------------- |
| Boost.Beast | CRLF injection in HTTP headers                                                                        | Medium        | Open                      |
| Boost.Regex | Stack overflow through recursive regular expression processing involving multiple `end_line` elements | Low           | Closed                    |
| Boost.Regex | Stack overflow through recursive processing of unions and capture groups                              | Low           | Closed                    |
| Boost.Regex | Stack overflow through recursive processing of multiple open parentheses in format strings            | Low           | Closed                    |
| Boost.Graph | Stack overflow through recursive processing of multiple subgraphs                                     | Low           | Closed                    |
| Boost.Graph | Assertion failure in `breadth_first_search`                                                           | Informational | Open                      |
| Boost.DLL   | Denial of service involving uncaught exceptions and failed assertions                                 | Informational | Open                      |

[image](https://www.google.com/s2/favicons?domain=https://ostif.org\&sz=32)

Boost+2

**Important finding: Boost.Beast HTTP header injection**

The audit identified that certain HTTP header-setting operations did not validate carriage-return and line-feed (CRLF) characters in user-controlled values.

Depending on application implementation, this could allow an attacker to inject additional HTTP headers or potentially perform request-smuggling and response-splitting attacks.

The audit report classified this finding as Medium and Open. It also documented that the maintainers accepted the associated risk rather than changing the library behavior, placing input validation responsibility on applications using the affected functionality.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://ostif.org\&sz=32)

Boost+1



### **3.6 Fuzzing results**

The Shielder audit expanded the Boost fuzzing infrastructure through 15 new fuzzing harnesses integrated into Google's OSS-Fuzz project.

The new harnesses covered libraries including:

- Boost.DLL
- Boost.Date_Time
- Boost.Filesystem
- Boost.GIL
- Boost.Graph
- Boost.JSON
- Boost.Program_Options
- Boost.Regex
- Boost.String_Algo
- Boost.UUID

The audit reported approximately:

| Measurement                          | Improvement   |
| ------------------------------------ | ------------- |
| Additional source-code line coverage | 4,500 lines   |
| Additional function coverage         | 700 functions |
| New fuzzing harnesses                | 15            |

The testing focused on parsing, input handling, file processing, regular expressions, and other functions that could expose security weaknesses when processing untrusted data.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://ostif.org\&sz=32)

Boost+1



Full report: [OSTIF – Boost Security Audit Report (PDF)](https://ostif.org/wp-content/uploads/2024/05/OSTIF-Boost-Report-PT-v1.4.pdf?utm_source=chatgpt.com).

## **4. Additional Independent Security Assessments**

### **4.1 Bishop Fox – Boost.Beast**

Boost.Beast also underwent independent security testing by Bishop Fox, commissioned by the C++ Alliance.

Documented assessments include:

| Year | Security activity                      | Scope                                 |
| ---- | -------------------------------------- | ------------------------------------- |
| 2017 | Hybrid application security assessment | Boost.Beast HTTP/S networking library |
| 2020 | Follow-up security assessment          | Further testing of Boost.Beast        |

The testing methodology included automated scanning, source-code analysis, architecture analysis, business-logic testing, and manual validation of identified vulnerabilities.

These assessments specifically concerned Boost.Beast rather than the entire Boost library collection.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://www.boost.org\&sz=32)

boost.org+1



Reference: [Boost.Beast – Bishop Fox Security Assessment Documentation](https://www.boost.org/latest/libs/beast/doc/html/beast/quick_start/security_review_bishop_fox.html?utm_source=chatgpt.com).

## **5. Cybersecurity Expertise and Security Activities**

Boost's cybersecurity-related activities include secure C++ programming guidance, source-code analysis, fuzz testing, memory-safety testing, and independent security assessments.

### **5.1 Secure C++ development**

Boost's contributor documentation identifies several major security weaknesses associated with C++ development.

| Security area       | Common vulnerabilities                                                    |
| ------------------- | ------------------------------------------------------------------------- |
| Memory safety       | Buffer overflows, use-after-free, memory leaks, null pointer dereferences |
| Integer safety      | Integer overflows and underflows                                          |
| Input validation    | Improper validation, injection, malformed input                           |
| Type safety         | Unsafe conversions and incompatible pointer operations                    |
| Concurrency         | Race conditions, data races, and synchronization problems                 |
| Resource management | Memory exhaustion and resource leaks                                      |
| API security        | Insecure or deprecated functions                                          |

Boost also provides libraries that support safer programming practices.

Examples include:

| Boost library     | Security-related functionality                    |
| ----------------- | ------------------------------------------------- |
| Boost.SmartPtr    | Smart pointer and memory ownership management     |
| Boost.Optional    | Type-safe representation of optional values       |
| Boost.Assert      | Runtime assertions and preconditions              |
| Boost.Contract    | Function contracts, preconditions, and invariants |
| Boost.String_Algo | String manipulation                               |
| Boost.Tokenizer   | Structured string tokenization                    |

These libraries provide programming mechanisms that can help developers implement safer applications. They do not independently guarantee application security.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://docs.cppalliance.org\&sz=32)

docs.cppalliance.org



### **5.2 Static and dynamic security testing**

Boost's contributor documentation describes several techniques for identifying security weaknesses in C++ software.

**Static analysis**

Examines source code without executing the program. This can identify potentially unsafe operations, incorrect memory handling, integer issues, and input-validation problems.

**Dynamic analysis**

Examines program behavior during execution and can identify memory errors, runtime defects, and concurrency problems.

**Memory sanitizers**

Examples include:

- AddressSanitizer (ASan)
- MemorySanitizer (MSan)
- ThreadSanitizer (TSan)
- UndefinedBehaviorSanitizer (UBSan)

**Fuzz testing**

Provides malformed, random, or unexpected input to software to identify crashes, hangs, unexpected behavior, and memory-safety issues.

**Penetration testing**

Uses simulated attack techniques to identify vulnerabilities in software implementations and applications using Boost.

These techniques are documented in the [Boost Contributor Security Guide](https://docs.cppalliance.org/contributor-guide/cfaq/security.html?utm_source=chatgpt.com).&#x20;

[image](https://www.google.com/s2/favicons?domain=https://docs.cppalliance.org\&sz=32)

docs.cppalliance.org



### **5.3 OSS-Fuzz integration**

Boost participates in Google's OSS-Fuzz ecosystem.

OSS-Fuzz provides continuous fuzz testing for open-source projects and helps identify potential security vulnerabilities through automated execution of fuzzing harnesses.

The 2024 Shielder audit expanded Boost's fuzzing coverage through 15 additional harnesses.

The harnesses target components such as JSON parsing, regular expression processing, filesystem operations, image processing, and graph parsing.

Project: [Google OSS-Fuzz – Boost](https://github.com/google/oss-fuzz/tree/master/projects/boost?utm_source=chatgpt.com).&#x20;

[image](https://www.google.com/s2/favicons?domain=https://ostif.org\&sz=32)

ostif.org+1



### **5.4 Security governance and supply-chain security**

The 2024 Shielder audit also documented security governance and software supply-chain issues.

The report identified the following conditions at the time of the audit:

| Security area            | Condition identified                                                                               |
| ------------------------ | -------------------------------------------------------------------------------------------------- |
| Vulnerability disclosure | No centralized vulnerability disclosure process was in place                                       |
| Security reporting       | Vulnerability reporting channels were fragmented across individual library maintainers             |
| Release integrity        | Downloadable source releases did not provide digital signatures                                    |
| Git authenticity         | Most commits and tags were not signed by developers                                                |
| Fuzzing coverage         | Only a limited number of entry points in selected libraries were covered                           |
| Audit coverage           | Most of Boost's approximately 150 libraries had not previously undergone dedicated security audits |

The report also identified differences in security maturity among individual Boost libraries, reflecting their independent maintenance structures and development activity.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://ostif.org\&sz=32)

Boost+1



These observations describe the state documented in the May 2024 audit and should not automatically be interpreted as the current state of every Boost repository or release.

## **6. Consolidated Security Information**

| Category                             | Documented information                                                                                                    |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------- |
| Software type                        | Open-source C++ library collection                                                                                        |
| Number of libraries                  | Approximately 150                                                                                                         |
| Published CVEs                       | Historical vulnerabilities and newly published Boost.JSON vulnerabilities                                                 |
| Independent security auditors        | Shielder and Bishop Fox                                                                                                   |
| Security audit sponsorship           | Amazon Web Services                                                                                                       |
| Audit facilitator                    | Open Source Technology Improvement Fund                                                                                   |
| Major audit                          | Shielder security audit, 2023–2024                                                                                        |
| Audited Boost version                | 1.83.0                                                                                                                    |
| Libraries included in major audit    | 12                                                                                                                        |
| Security findings                    | 7                                                                                                                         |
| Critical findings in 2024 audit      | 0                                                                                                                         |
| High findings in 2024 audit          | 0                                                                                                                         |
| Medium findings in 2024 audit        | 1                                                                                                                         |
| Low findings in 2024 audit           | 4                                                                                                                         |
| Informational findings in 2024 audit | 2                                                                                                                         |
| New fuzzing harnesses                | 15                                                                                                                        |
| Fuzzing infrastructure               | Google OSS-Fuzz, ClusterFuzzLite, AFL++                                                                                   |
| Static analysis tools                | CodeQL, Semgrep                                                                                                           |
| Memory-safety testing                | AddressSanitizer                                                                                                          |
| Security documentation               | Boost Contributor Security Guide                                                                                          |
| Security governance                  | Centralized vulnerability reporting and supply-chain controls identified as areas requiring improvement in the 2024 audit |

## **7. Primary Sources and References**

**Vulnerability databases**

1. [National Vulnerability Database (NVD)](https://nvd.nist.gov/?utm_source=chatgpt.com)
2. [CVE Program](https://www.cve.org/?utm_source=chatgpt.com)
3. [Open Source Vulnerabilities (OSV)](https://osv.dev/?utm_source=chatgpt.com)

**Boost security documentation and audits**

4. [OSTIF – Boost Security Audit Report, May 2024](https://ostif.org/wp-content/uploads/2024/05/OSTIF-Boost-Report-PT-v1.4.pdf?utm_source=chatgpt.com)
5. [OSTIF – Boost Audit Announcement](https://ostif.org/boost-audit-complete/?utm_source=chatgpt.com)
6. [Boost Contributor Security Guide](https://docs.cppalliance.org/contributor-guide/cfaq/security.html?utm_source=chatgpt.com)
7. [Boost.Beast – Bishop Fox Security Assessment Documentation](https://www.boost.org/latest/libs/beast/doc/html/beast/quick_start/security_review_bishop_fox.html?utm_source=chatgpt.com)

**Security testing infrastructure**

8\. [Google OSS-Fuzz – Boost Project](https://github.com/google/oss-fuzz/tree/master/projects/boost?utm_source=chatgpt.com)

**Current Boost.JSON vulnerability fixes**

9. [Boost.JSON PR #1226 – Parser state reset](https://github.com/boostorg/json/pull/1226?utm_source=chatgpt.com)
10. [Boost.JSON PR #1227 – Memory allocation growth](https://github.com/boostorg/json/pull/1227?utm_source=chatgpt.com)

**End of report.**
