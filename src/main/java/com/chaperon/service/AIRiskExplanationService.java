package com.chaperon.service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;

import com.chaperon.model.SubmissionRiskResult;

public class AIRiskExplanationService {

    /*
     * =====================================================
     * GEMINI CONFIGURATION
     * =====================================================
     */
    private static final String MODEL =
            "gemini-3.6-flash";

    private static final String API_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/"
            + MODEL
            + ":generateContent";

    private final HttpClient httpClient;

    /*
     * =====================================================
     * CONSTRUCTOR
     * =====================================================
     */
    public AIRiskExplanationService() {

        httpClient =
                HttpClient
                        .newBuilder()
                        .connectTimeout(
                                Duration.ofSeconds(15)
                        )
                        .build();
    }

    /*
     * =====================================================
     * GENERATE AI RISK EXPLANATION
     * =====================================================
     */
    public String generateExplanation(
            String approvalName,
            String businessName,
            SubmissionRiskResult riskResult) {

        /*
         * =================================================
         * NULL SAFETY
         * =================================================
         */
        if (riskResult == null) {

            return "AI risk explanation is not available.";
        }

        /*
         * =================================================
         * READ GEMINI API KEY
         * =================================================
         */
        String apiKey =
                System.getenv(
                        "GEMINI_API_KEY"
                );

        /*
         * =================================================
         * API KEY NOT FOUND
         * =================================================
         */
        if (apiKey == null ||
            apiKey.isBlank()) {

            System.out.println(
                    "GEMINI_API_KEY not found."
            );

            return buildFallbackExplanation(
                    riskResult
            );
        }

        try {

            /*
             * =============================================
             * BUILD CHAPERON PROMPT
             * =============================================
             */
            String prompt =
                    buildPrompt(
                            approvalName,
                            businessName,
                            riskResult
                    );

            /*
             * =============================================
             * BUILD GEMINI JSON REQUEST
             * =============================================
             */
            String requestBody =
                    "{"
                    + "\"contents\":["
                    + "{"
                    + "\"role\":\"user\","
                    + "\"parts\":["
                    + "{"
                    + "\"text\":\""
                    + escapeJson(prompt)
                    + "\""
                    + "}"
                    + "]"
                    + "}"
                    + "]"
                    + "}";

            /*
             * =============================================
             * BUILD HTTP REQUEST
             *
             * API KEY IS SENT THROUGH HEADER.
             * IT IS NOT ADDED TO THE URL.
             * =============================================
             */
            HttpRequest request =
                    HttpRequest
                            .newBuilder()
                            .uri(
                                    URI.create(
                                            API_URL
                                    )
                            )
                            .timeout(
                                    Duration.ofSeconds(30)
                            )
                            .header(
                                    "Content-Type",
                                    "application/json"
                            )
                            .header(
                                    "x-goog-api-key",
                                    apiKey
                            )
                            .POST(
                                    HttpRequest
                                            .BodyPublishers
                                            .ofString(
                                                    requestBody
                                            )
                            )
                            .build();

            /*
             * =============================================
             * SEND REQUEST TO GEMINI
             * =============================================
             */
            HttpResponse<String> response =
                    httpClient.send(
                            request,
                            HttpResponse
                                    .BodyHandlers
                                    .ofString()
                    );

            /*
             * =============================================
             * HANDLE GEMINI API ERROR
             * =============================================
             */
            if (response.statusCode() < 200 ||
                response.statusCode() >= 300) {

                System.out.println(
                        "Gemini API Error: "
                        + response.statusCode()
                );

                System.out.println(
                        response.body()
                );

                return buildFallbackExplanation(
                        riskResult
                );
            }

            /*
             * =============================================
             * EXTRACT AI TEXT
             * =============================================
             */
            String aiText =
                    extractGeminiText(
                            response.body()
                    );

            /*
             * =============================================
             * EMPTY AI RESPONSE
             * =============================================
             */
            if (aiText == null ||
                aiText.isBlank()) {

                System.out.println(
                        "Gemini returned an empty response."
                );

                return buildFallbackExplanation(
                        riskResult
                );
            }

            /*
             * =============================================
             * SUCCESS
             * =============================================
             */
            System.out.println(
                    "Gemini AI risk guidance generated successfully."
            );

            return aiText;

        } catch (IOException e) {

            System.out.println(
                    "Gemini IOException: "
                    + e.getMessage()
            );

            return buildFallbackExplanation(
                    riskResult
            );

        } catch (InterruptedException e) {

            Thread.currentThread()
                    .interrupt();

            System.out.println(
                    "Gemini request was interrupted."
            );

            return buildFallbackExplanation(
                    riskResult
            );

        } catch (Exception e) {

            System.out.println(
                    "Gemini unexpected error: "
                    + e.getMessage()
            );

            return buildFallbackExplanation(
                    riskResult
            );
        }
    }

    /*
     * =====================================================
     * BUILD PROMPT
     * =====================================================
     */
    private String buildPrompt(
            String approvalName,
            String businessName,
            SubmissionRiskResult riskResult) {

        StringBuilder prompt =
                new StringBuilder();

        /*
         * =================================================
         * AI ROLE
         * =================================================
         */
        prompt.append(
                "You are CHAPERON, an AI-assisted regulatory "
                + "guidance system for Indian entrepreneurs.\n\n"
        );

        /*
         * =================================================
         * IMPORTANT SAFETY / ACCURACY RULES
         * =================================================
         */
        prompt.append(
                "IMPORTANT RULES:\n"
        );

        prompt.append(
                "1. Do not change or recalculate the supplied "
                + "risk score.\n"
        );

        prompt.append(
                "2. CHAPERON's deterministic rule engine is "
                + "the source of truth for this analysis.\n"
        );

        prompt.append(
                "3. Do not promise government approval.\n"
        );

        prompt.append(
                "4. Do not invent laws, regulations, documents "
                + "or approval requirements.\n"
        );

        prompt.append(
                "5. Explain only the information supplied "
                + "by CHAPERON.\n"
        );

        prompt.append(
                "6. Keep the guidance short, simple and "
                + "practical for an entrepreneur.\n"
        );

        prompt.append(
                "7. Final statutory scrutiny and approval remain "
                + "with the concerned government authority.\n\n"
        );

        /*
         * =================================================
         * BUSINESS INFORMATION
         * =================================================
         */
        prompt.append(
                "BUSINESS INFORMATION\n"
        );

        prompt.append(
                "Business: "
                + safeValue(
                        businessName
                )
                + "\n"
        );

        prompt.append(
                "Approval: "
                + safeValue(
                        approvalName
                )
                + "\n\n"
        );

        /*
         * =================================================
         * RULE ENGINE RESULT
         * =================================================
         */
        prompt.append(
                "CHAPERON RULE ENGINE RESULT\n"
        );

        prompt.append(
                "Risk Score: "
                + riskResult.getRiskScore()
                + "/100\n"
        );

        prompt.append(
                "Risk Level: "
                + safeValue(
                        riskResult.getRiskLevel()
                )
                + "\n"
        );

        prompt.append(
                "Readiness: "
                + riskResult.getReadinessPercentage()
                + "%\n"
        );

        prompt.append(
                "Safe To Submit: "
                + (
                    riskResult.isSafeToSubmit()
                    ? "YES"
                    : "NO"
                )
                + "\n\n"
        );

        /*
         * =================================================
         * DETECTED ISSUES
         * =================================================
         */
        prompt.append(
                "DETECTED ISSUES\n"
        );

        List<String> reasons =
                riskResult.getRiskReasons();

        if (reasons != null &&
            !reasons.isEmpty()) {

            for (String reason : reasons) {

                prompt.append(
                        "- "
                        + safeValue(
                                reason
                        )
                        + "\n"
                );
            }

        } else {

            prompt.append(
                    "- No major pre-submission issue "
                    + "was detected.\n"
            );
        }

        /*
         * =================================================
         * SYSTEM RECOMMENDATIONS
         * =================================================
         */
        prompt.append(
                "\nSYSTEM RECOMMENDATIONS\n"
        );

        List<String> recommendations =
                riskResult.getRecommendations();

        if (recommendations != null &&
            !recommendations.isEmpty()) {

            for (
                String recommendation
                : recommendations
            ) {

                prompt.append(
                        "- "
                        + safeValue(
                                recommendation
                        )
                        + "\n"
                );
            }

        } else {

            prompt.append(
                    "- No additional recommendation "
                    + "is currently available.\n"
            );
        }

        /*
         * =================================================
         * REQUIRED OUTPUT FORMAT
         * =================================================
         */
        prompt.append(
                "\nReturn ONLY the following three sections. "
                + "Do not add markdown headings, bullets, "
                + "asterisks or extra sections.\n\n"
        );

        prompt.append(
                "Risk Explanation: "
                + "<Explain the current risk result in "
                + "2 short sentences.>\n"
        );

        prompt.append(
                "Priority Action: "
                + "<Give the single most important next action.>\n"
        );

        prompt.append(
                "Submission Advice: "
                + "<Give one short practical recommendation.>"
        );

        return prompt.toString();
    }

    /*
     * =====================================================
     * EXTRACT GEMINI TEXT
     * =====================================================
     */
    private String extractGeminiText(
            String json) {

        if (json == null ||
            json.isBlank()) {

            return null;
        }

        /*
         * =================================================
         * GEMINI RESPONSE CONTAINS:
         *
         * "parts": [
         *     {
         *         "text": "..."
         *     }
         * ]
         *
         * FIND FIRST TEXT FIELD
         * =================================================
         */
        String marker =
                "\"text\"";

        int markerPosition =
                json.indexOf(marker);

        if (markerPosition == -1) {

            return null;
        }

        /*
         * =================================================
         * FIND COLON AFTER "text"
         * =================================================
         */
        int colonPosition =
                json.indexOf(
                        ':',
                        markerPosition
                        + marker.length()
                );

        if (colonPosition == -1) {

            return null;
        }

        /*
         * =================================================
         * FIND OPENING QUOTE
         * =================================================
         */
        int start =
                json.indexOf(
                        '"',
                        colonPosition + 1
                );

        if (start == -1) {

            return null;
        }

        start++;

        StringBuilder result =
                new StringBuilder();

        boolean escaped =
                false;

        /*
         * =================================================
         * READ JSON STRING
         * =================================================
         */
        for (
            int i = start;
            i < json.length();
            i++
        ) {

            char c =
                    json.charAt(i);

            /*
             * =============================================
             * ESCAPED CHARACTER
             * =============================================
             */
            if (escaped) {

                switch (c) {

                    case 'n':
                        result.append('\n');
                        break;

                    case 'r':
                        result.append('\r');
                        break;

                    case 't':
                        result.append('\t');
                        break;

                    case '"':
                        result.append('"');
                        break;

                    case '\\':
                        result.append('\\');
                        break;

                    case '/':
                        result.append('/');
                        break;

                    case 'b':
                        result.append('\b');
                        break;

                    case 'f':
                        result.append('\f');
                        break;

                    default:
                        result.append(c);
                        break;
                }

                escaped = false;

                continue;
            }

            /*
             * =============================================
             * ESCAPE START
             * =============================================
             */
            if (c == '\\') {

                escaped = true;

                continue;
            }

            /*
             * =============================================
             * END OF JSON STRING
             * =============================================
             */
            if (c == '"') {

                break;
            }

            result.append(c);
        }

        return result
                .toString()
                .trim();
    }

    /*
     * =====================================================
     * FALLBACK EXPLANATION
     * =====================================================
     */
    private String buildFallbackExplanation(
            SubmissionRiskResult result) {

        /*
         * =================================================
         * SAFE TO SUBMIT
         * =================================================
         */
        if (result.isSafeToSubmit()) {

            return "Risk Explanation: CHAPERON did not detect "
                    + "any major pre-submission issue. "
                    + "Your mandatory requirements appear ready "
                    + "based on the available data.\n"
                    + "Priority Action: Review the application "
                    + "details once before final submission.\n"
                    + "Submission Advice: Proceed only after "
                    + "confirming that all submitted information "
                    + "is accurate and current.";
        }

        /*
         * =================================================
         * HIGH RISK
         * =================================================
         */
        if ("HIGH".equalsIgnoreCase(
                result.getRiskLevel()
        )) {

            return "Risk Explanation: CHAPERON detected high "
                    + "pre-submission risk based on the current "
                    + "profile and document readiness.\n"
                    + "Priority Action: Resolve the identified "
                    + "mandatory requirements before submission.\n"
                    + "Submission Advice: Do not submit until "
                    + "the major detected issues have been fixed.";
        }

        /*
         * =================================================
         * MEDIUM RISK
         * =================================================
         */
        if ("MEDIUM".equalsIgnoreCase(
                result.getRiskLevel()
        )) {

            return "Risk Explanation: Some issues may affect "
                    + "the application's submission readiness.\n"
                    + "Priority Action: Review the detected "
                    + "issues and CHAPERON's recommended fixes.\n"
                    + "Submission Advice: Resolve the remaining "
                    + "issues before final submission.";
        }

        /*
         * =================================================
         * LOW RISK
         * =================================================
         */
        return "Risk Explanation: The application currently "
                + "has low pre-submission risk based on "
                + "CHAPERON's available checks.\n"
                + "Priority Action: Review any remaining "
                + "guidance before submission.\n"
                + "Submission Advice: Verify all information "
                + "before proceeding with final submission.";
    }

    /*
     * =====================================================
     * ESCAPE STRING FOR JSON
     * =====================================================
     */
    private String escapeJson(
            String value) {

        if (value == null) {

            return "";
        }

        return value
                .replace(
                        "\\",
                        "\\\\"
                )
                .replace(
                        "\"",
                        "\\\""
                )
                .replace(
                        "\n",
                        "\\n"
                )
                .replace(
                        "\r",
                        "\\r"
                )
                .replace(
                        "\t",
                        "\\t"
                );
    }

    /*
     * =====================================================
     * SAFE STRING VALUE
     * =====================================================
     */
    private String safeValue(
            String value) {

        if (value == null ||
            value.isBlank()) {

            return "Not Available";
        }

        return value.trim();
    }
}