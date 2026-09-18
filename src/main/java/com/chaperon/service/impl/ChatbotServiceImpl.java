package com.chaperon.service.impl;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import com.chaperon.service.ChatbotService;

public class ChatbotServiceImpl implements ChatbotService {

    @Override
    public String askCera(
            String question,
            String userContext) {

        if (question == null || question.isBlank()) {

            return "Please ask me something about CHAPERON, approvals, documents, applications or compliance.";
        }

        String apiKey =
                System.getenv("GEMINI_API_KEY");

        if (apiKey == null || apiKey.isBlank()) {

            return "CERA is temporarily unavailable. You can continue using CHAPERON manually.";
        }

        String model = "gemini-3.1-flash-lite";

        try {

            String systemPrompt =
                    """
                    You are CERA, the CHAPERON Regulatory Assistant.

                    CHAPERON is an industrial approval, compliance
                    and regulatory guidance platform.

                    Your objective is simple:

                    A user should not need to leave CHAPERON just because
                    they do not understand the website, an approval,
                    licence, NOC, document requirement, application,
                    officer query, inspection, compliance requirement,
                    renewal or government scheme.

                    You help users with:

                    WEBSITE GUIDANCE
                    - Dashboard
                    - Business Profile
                    - Approval Roadmap
                    - Approval Journey
                    - Journey Optimizer
                    - Document Vault
                    - Applications
                    - Inspections
                    - Government Schemes
                    - Compliance
                    - Notifications
                    - Profile
                    - What-If Simulator
                    - Explain My Delay
                    - Compliance Health
                    - Regulation Impact
                    - Document Pre-Validation

                    REGULATORY GUIDANCE
                    - Industrial approvals
                    - Registrations
                    - Licences
                    - NOCs
                    - Required documents
                    - Application processes
                    - Queries
                    - Inspections
                    - Renewals
                    - Compliance
                    - Government support services

                    RESPONSE RULES

                    1. Keep answers simple and practical.
                    2. Prefer short step-by-step guidance.
                    3. If user writes Hindi or Hinglish, answer in Hinglish.
                    4. If user writes English, answer in English.
                    5. Never guarantee an approval.
                    6. Never pretend to be a government officer.
                    7. Never claim CHAPERON is an official government authority.
                    8. Never invent statutory requirements.
                    9. When regulatory information is uncertain,
                       tell the user to verify it with the concerned authority.
                    10. Whenever possible tell the user which CHAPERON
                        section they should use next.
                    11. Manual use of CHAPERON is always available.
                        AI assistance is optional.
                    12. Do not unnecessarily tell users to leave CHAPERON.
                    13. Do not request passwords, OTPs or sensitive credentials.

                    Your name is CERA.

                    CERA is the intelligent guidance layer of CHAPERON.
                    """;

            String context =
                    userContext == null
                            ? "The user is currently visiting CHAPERON."
                            : userContext;

            String prompt =
                    systemPrompt
                    + "\n\nCURRENT USER CONTEXT:\n"
                    + context
                    + "\n\nUSER QUESTION:\n"
                    + question
                    + "\n\nCERA RESPONSE:\n";

            String requestJson =
                    "{"
                    + "\"contents\":[{"
                    + "\"parts\":[{"
                    + "\"text\":\""
                    + escapeJson(prompt)
                    + "\""
                    + "}]"
                    + "}]"
                    + "}";

            String url =
                    "https://generativelanguage.googleapis.com/v1beta/models/"
                    + model
                    + ":generateContent?key="
                    + apiKey;

            HttpRequest httpRequest =
                    HttpRequest
                            .newBuilder()
                            .uri(URI.create(url))
                            .header(
                                    "Content-Type",
                                    "application/json"
                            )
                            .POST(
                                    HttpRequest.BodyPublishers
                                            .ofString(requestJson)
                            )
                            .build();

            HttpClient client =
                    HttpClient
                            .newBuilder()
                            .build();

            HttpResponse<String> httpResponse =
                    client.send(
                            httpRequest,
                            HttpResponse.BodyHandlers.ofString()
                    );

            if (httpResponse.statusCode() < 200
                    || httpResponse.statusCode() >= 300) {

                System.out.println("======================================");
                System.out.println("CERA GEMINI ERROR");
                System.out.println("STATUS CODE: " + httpResponse.statusCode());
                System.out.println("RESPONSE:");
                System.out.println(httpResponse.body());
                System.out.println("======================================");

                return "CERA could not connect to the AI service right now. Please try again.";
            }

            String answer =
                    extractGeminiText(
                            httpResponse.body()
                    );

            if (answer == null || answer.isBlank()) {

                return "I could not generate a response. Please try asking your question again.";
            }

            return answer;

        } catch (Exception e) {

            System.out.println("======================================");
            System.out.println("CERA EXCEPTION");
            e.printStackTrace();
            System.out.println("======================================");

            return "CERA is temporarily unable to respond. Please try again.";
        }
    }


    private String extractGeminiText(
            String responseBody) {

        if (responseBody == null
                || responseBody.isBlank()) {

            return null;
        }

        String marker =
                "\"text\":";

        int position =
                responseBody.indexOf(marker);

        if (position < 0) {

            return null;
        }

        int startQuote =
                responseBody.indexOf(
                        '"',
                        position + marker.length()
                );

        if (startQuote < 0) {

            return null;
        }

        StringBuilder result =
                new StringBuilder();

        boolean escaped =
                false;

        for (int i = startQuote + 1;
             i < responseBody.length();
             i++) {

            char ch =
                    responseBody.charAt(i);

            if (escaped) {

                switch (ch) {

                    case 'n':
                    case 'r':
                    case 't':
                        result.append(' ');
                        break;

                    case '"':
                        result.append('"');
                        break;

                    case '\\':
                        result.append('\\');
                        break;

                    default:
                        result.append(ch);
                        break;
                }

                escaped = false;

                continue;
            }

            if (ch == '\\') {

                escaped = true;

                continue;
            }

            if (ch == '"') {

                break;
            }

            result.append(ch);
        }

        return result.toString().trim();
    }


    private String escapeJson(
            String text) {

        if (text == null) {

            return "";
        }

        return text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}