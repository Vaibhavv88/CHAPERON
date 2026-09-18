<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>

/* =========================================================
   CERA ROOT
   ========================================================= */

#ceraChatPanel,
#ceraChatPanel *,
#ceraFloatingButton,
#ceraFloatingButton * {
    box-sizing: border-box;
}


/* =========================================================
   FLOATING BUTTON
   ========================================================= */

#ceraFloatingButton {
    position: fixed !important;

    right: 25px !important;
    bottom: 25px !important;

    width: 72px !important;
    height: 72px !important;

    margin: 0 !important;
    padding: 3px !important;

    border: 3px solid #ffffff !important;
    border-radius: 50% !important;

    background: #ffffff !important;

    cursor: pointer !important;

    z-index: 99998 !important;

    box-shadow:
        0 12px 35px rgba(37, 99, 235, 0.35) !important;

    overflow: visible !important;

    transition:
        transform 0.25s ease,
        box-shadow 0.25s ease !important;
}


#ceraFloatingButton:hover {
    transform: scale(1.07) !important;

    box-shadow:
        0 16px 42px rgba(37, 99, 235, 0.45) !important;
}


#ceraFloatingButton img {
    display: block !important;

    width: 100% !important;
    height: 100% !important;

    margin: 0 !important;
    padding: 0 !important;

    object-fit: cover !important;
    object-position: center !important;

    border-radius: 50% !important;
}


.cera-online-dot {
    position: absolute !important;

    right: 0 !important;
    bottom: 5px !important;

    display: block !important;

    width: 15px !important;
    height: 15px !important;

    border: 3px solid #ffffff !important;
    border-radius: 50% !important;

    background: #22c55e !important;
}


/* =========================================================
   CHAT PANEL
   ========================================================= */

#ceraChatPanel {
    position: fixed !important;

    right: 25px !important;
    bottom: 110px !important;

    width: 400px !important;
    height: 590px !important;

    max-height: calc(100vh - 135px) !important;

    display: none;

    flex-direction: column !important;

    margin: 0 !important;
    padding: 0 !important;

    overflow: hidden !important;

    border: 1px solid #dbeafe !important;
    border-radius: 22px !important;

    background: #ffffff !important;

    z-index: 99999 !important;

    box-shadow:
        0 24px 65px rgba(15, 23, 42, 0.25) !important;

    font-family:
        Arial,
        Helvetica,
        sans-serif !important;

    text-align: left !important;
}


#ceraChatPanel.cera-open {
    display: flex !important;
}


/* =========================================================
   HEADER
   ========================================================= */

.cera-header {
    display: flex !important;

    align-items: center !important;

    gap: 12px !important;

    min-height: 96px !important;

    padding: 16px !important;

    margin: 0 !important;

    flex-shrink: 0 !important;

    text-align: left !important;

    color: #ffffff !important;

    background:
        linear-gradient(
            135deg,
            #123fa8 0%,
            #2563eb 55%,
            #0ea5e9 100%
        ) !important;
}


.cera-header-logo {
    display: block !important;

    width: 58px !important;
    height: 58px !important;

    min-width: 58px !important;
    min-height: 58px !important;

    max-width: 58px !important;
    max-height: 58px !important;

    margin: 0 !important;
    padding: 0 !important;

    flex-shrink: 0 !important;

    object-fit: cover !important;
    object-position: center !important;

    border: 3px solid #ffffff !important;
    border-radius: 50% !important;

    background: #ffffff !important;
}


.cera-header-text {
    display: block !important;

    flex: 1 !important;

    min-width: 0 !important;

    margin: 0 !important;
    padding: 0 !important;

    text-align: left !important;
}


.cera-header-name {
    display: block !important;

    margin: 0 !important;
    padding: 0 !important;

    color: #ffffff !important;

    font-size: 22px !important;
    font-weight: 800 !important;

    line-height: 1.2 !important;

    text-align: left !important;
}


.cera-header-subtitle {
    display: block !important;

    margin: 3px 0 0 0 !important;
    padding: 0 !important;

    color: rgba(255, 255, 255, 0.95) !important;

    font-size: 12px !important;
    font-weight: 500 !important;

    line-height: 1.3 !important;

    text-align: left !important;
}


.cera-header-status {
    display: flex !important;

    align-items: center !important;

    gap: 6px !important;

    margin: 5px 0 0 0 !important;
    padding: 0 !important;

    color: rgba(255, 255, 255, 0.92) !important;

    font-size: 11px !important;

    line-height: 1.3 !important;

    text-align: left !important;
}


.cera-header-status-dot {
    display: block !important;

    width: 8px !important;
    height: 8px !important;

    min-width: 8px !important;

    border-radius: 50% !important;

    background: #4ade80 !important;
}


#ceraCloseButton {
    display: flex !important;

    align-items: center !important;
    justify-content: center !important;

    width: 38px !important;
    height: 38px !important;

    min-width: 38px !important;

    margin: 0 !important;
    padding: 0 !important;

    border: none !important;
    border-radius: 11px !important;

    background:
        rgba(255, 255, 255, 0.15) !important;

    color: #ffffff !important;

    cursor: pointer !important;

    font-size: 26px !important;
    line-height: 1 !important;
}


#ceraCloseButton:hover {
    background:
        rgba(255, 255, 255, 0.26) !important;
}


/* =========================================================
   MESSAGES AREA
   ========================================================= */

#ceraMessages {
    display: block !important;

    flex: 1 !important;

    min-height: 0 !important;

    margin: 0 !important;

    padding: 18px !important;

    overflow-x: hidden !important;
    overflow-y: auto !important;

    text-align: left !important;

    background:
        linear-gradient(
            180deg,
            #f8fbff 0%,
            #ffffff 100%
        ) !important;
}


.cera-message-row {
    display: flex !important;

    width: 100% !important;

    margin: 0 0 14px 0 !important;
    padding: 0 !important;

    text-align: left !important;
}


.cera-bot-row {
    align-items: flex-start !important;
    justify-content: flex-start !important;

    gap: 10px !important;
}


.cera-user-row {
    align-items: flex-end !important;
    justify-content: flex-end !important;
}


.cera-mini-logo {
    display: block !important;

    width: 38px !important;
    height: 38px !important;

    min-width: 38px !important;
    min-height: 38px !important;

    max-width: 38px !important;
    max-height: 38px !important;

    margin: 0 !important;
    padding: 0 !important;

    flex-shrink: 0 !important;

    object-fit: cover !important;
    object-position: center !important;

    border-radius: 50% !important;

    background: #ffffff !important;

    box-shadow:
        0 3px 10px rgba(37, 99, 235, 0.15) !important;
}


.cera-message-bubble {
    display: block !important;

    max-width: 80% !important;

    margin: 0 !important;

    padding: 12px 14px !important;

    border-radius: 16px !important;

    font-size: 13px !important;
    font-weight: 400 !important;

    line-height: 1.55 !important;

    letter-spacing: normal !important;

    text-align: left !important;

    white-space: normal !important;

    word-break: normal !important;

    overflow-wrap: break-word !important;
}


.cera-bot-bubble {
    color: #172554 !important;

    background: #eef5ff !important;

    border:
        1px solid #dbeafe !important;

    border-top-left-radius: 5px !important;
}


.cera-user-bubble {
    color: #ffffff !important;

    background:
        linear-gradient(
            135deg,
            #2563eb,
            #0f5bd8
        ) !important;

    border-bottom-right-radius: 5px !important;
}


.cera-welcome-name {
    display: block !important;

    margin: 0 0 7px 0 !important;

    padding: 0 !important;

    color: #0f3ea8 !important;

    font-size: 14px !important;
    font-weight: 800 !important;

    line-height: 1.4 !important;

    text-align: left !important;
}


.cera-message-paragraph {
    display: block !important;

    margin: 0 0 8px 0 !important;
    padding: 0 !important;

    text-align: left !important;

    line-height: 1.55 !important;
}


.cera-message-paragraph:last-child {
    margin-bottom: 0 !important;
}


/* =========================================================
   QUICK HELP
   ========================================================= */

.cera-quick-area {
    display: block !important;

    margin: 0 !important;

    padding: 10px 15px 12px !important;

    flex-shrink: 0 !important;

    background: #ffffff !important;

    border-top:
        1px solid #eef2f7 !important;

    text-align: left !important;
}


.cera-quick-heading {
    display: block !important;

    margin: 0 0 8px 0 !important;
    padding: 0 !important;

    color: #475569 !important;

    font-size: 10px !important;
    font-weight: 800 !important;

    letter-spacing: 0.7px !important;

    text-transform: uppercase !important;

    text-align: left !important;
}


.cera-quick-buttons {
    display: flex !important;

    flex-wrap: wrap !important;

    gap: 7px !important;

    margin: 0 !important;
    padding: 0 !important;

    overflow: visible !important;
}


.cera-quick-button {
    display: inline-flex !important;

    align-items: center !important;
    justify-content: center !important;

    min-height: 34px !important;

    margin: 0 !important;

    padding: 7px 11px !important;

    border:
        1px solid #bfdbfe !important;

    border-radius: 18px !important;

    background: #eff6ff !important;

    color: #1d4ed8 !important;

    cursor: pointer !important;

    font-family:
        Arial,
        Helvetica,
        sans-serif !important;

    font-size: 11px !important;
    font-weight: 700 !important;

    line-height: 1.2 !important;

    text-align: center !important;

    white-space: nowrap !important;
}


.cera-quick-button:hover {
    background: #dbeafe !important;

    border-color: #60a5fa !important;
}


/* =========================================================
   INPUT
   ========================================================= */

.cera-input-section {
    display: block !important;

    margin: 0 !important;

    padding: 11px 14px 8px !important;

    flex-shrink: 0 !important;

    background: #ffffff !important;

    border-top:
        1px solid #e2e8f0 !important;
}


.cera-input-box {
    display: flex !important;

    align-items: center !important;

    gap: 8px !important;

    margin: 0 !important;

    padding: 5px !important;

    border:
        1px solid #cbd5e1 !important;

    border-radius: 15px !important;

    background: #f8fafc !important;
}


.cera-input-box:focus-within {
    border-color: #60a5fa !important;

    box-shadow:
        0 0 0 3px
        rgba(59, 130, 246, 0.10) !important;
}


#ceraInput {
    display: block !important;

    flex: 1 !important;

    min-width: 0 !important;

    height: 40px !important;

    margin: 0 !important;

    padding: 8px 10px !important;

    border: none !important;
    outline: none !important;

    background: transparent !important;

    color: #0f172a !important;

    font-family:
        Arial,
        Helvetica,
        sans-serif !important;

    font-size: 13px !important;
    font-weight: 400 !important;

    line-height: normal !important;

    text-align: left !important;
}


#ceraInput::placeholder {
    color: #94a3b8 !important;
}


#ceraSendButton {
    display: flex !important;

    align-items: center !important;
    justify-content: center !important;

    width: 42px !important;
    height: 42px !important;

    min-width: 42px !important;

    margin: 0 !important;
    padding: 0 !important;

    border: none !important;

    border-radius: 12px !important;

    background:
        linear-gradient(
            135deg,
            #2563eb,
            #0284c7
        ) !important;

    color: #ffffff !important;

    cursor: pointer !important;

    font-size: 19px !important;

    line-height: 1 !important;
}


#ceraSendButton:hover {
    transform: scale(1.04) !important;
}


#ceraSendButton:disabled {
    opacity: 0.5 !important;

    cursor: not-allowed !important;

    transform: none !important;
}


/* =========================================================
   DISCLAIMER
   ========================================================= */

.cera-disclaimer {
    display: block !important;

    margin: 0 !important;

    padding: 0 15px 11px !important;

    flex-shrink: 0 !important;

    background: #ffffff !important;

    color: #94a3b8 !important;

    font-size: 9px !important;

    line-height: 1.4 !important;

    text-align: center !important;
}


/* =========================================================
   TYPING
   ========================================================= */

.cera-typing-dots {
    display: inline-flex !important;

    align-items: center !important;

    gap: 4px !important;

    min-height: 18px !important;
}


.cera-typing-dots span {
    display: block !important;

    width: 6px !important;
    height: 6px !important;

    border-radius: 50% !important;

    background: #60a5fa !important;

    animation:
        ceraTypingAnimation
        1.1s infinite !important;
}


.cera-typing-dots span:nth-child(2) {
    animation-delay: 0.15s !important;
}


.cera-typing-dots span:nth-child(3) {
    animation-delay: 0.30s !important;
}


@keyframes ceraTypingAnimation {

    0%,
    60%,
    100% {

        transform: translateY(0);

        opacity: 0.45;
    }

    30% {

        transform: translateY(-5px);

        opacity: 1;
    }
}


/* =========================================================
   MOBILE
   ========================================================= */

@media (max-width: 600px) {

    #ceraChatPanel {

        left: 10px !important;
        right: 10px !important;

        bottom: 90px !important;

        width: auto !important;

        height:
            calc(100vh - 110px) !important;

        max-height: none !important;

        border-radius: 18px !important;
    }


    #ceraFloatingButton {

        right: 17px !important;
        bottom: 17px !important;

        width: 64px !important;
        height: 64px !important;
    }
}

</style>


<!-- ===================================================== -->
<!-- CERA FLOATING BUTTON -->
<!-- ===================================================== -->

<button
    id="ceraFloatingButton"
    type="button"
    title="Ask CERA">

    <img
        src="${pageContext.request.contextPath}/images/cera-logo.jpeg"
        alt="CERA"
    />

    <span class="cera-online-dot"></span>

</button>


<!-- ===================================================== -->
<!-- CERA CHAT PANEL -->
<!-- ===================================================== -->

<div id="ceraChatPanel">


    <!-- ================================================= -->
    <!-- HEADER -->
    <!-- ================================================= -->

    <div class="cera-header">

        <img
            src="${pageContext.request.contextPath}/images/cera-logo.jpeg"
            class="cera-header-logo"
            alt="CERA"
        />


        <div class="cera-header-text">

            <div class="cera-header-name">
                CERA
            </div>

            <div class="cera-header-subtitle">
                CHAPERON Regulatory Assistant
            </div>

            <div class="cera-header-status">

                <span class="cera-header-status-dot"></span>

                <span>
                    Online • Here to guide you
                </span>

            </div>

        </div>


        <button
            id="ceraCloseButton"
            type="button"
            title="Close">

            &times;

        </button>

    </div>


    <!-- ================================================= -->
    <!-- MESSAGES -->
    <!-- ================================================= -->

    <div id="ceraMessages">

        <div class="cera-message-row cera-bot-row">

            <img
                src="${pageContext.request.contextPath}/images/cera-logo.jpeg"
                class="cera-mini-logo"
                alt="CERA"
            />


            <div class="cera-message-bubble cera-bot-bubble">

                <div class="cera-welcome-name">
                    Hello! I'm CERA 👋
                </div>

                <div class="cera-message-paragraph">
                    I'm your CHAPERON Regulatory Assistant.
                </div>

                <div class="cera-message-paragraph">
                    I can help you understand approvals,
                    licences, NOCs, required documents,
                    applications, inspections, compliance
                    and how to use CHAPERON.
                </div>

                <div class="cera-message-paragraph">
                    How can I help you today?
                </div>

            </div>

        </div>

    </div>


    <!-- ================================================= -->
    <!-- QUICK HELP -->
    <!-- ================================================= -->

    <div class="cera-quick-area">

        <div class="cera-quick-heading">
            Quick Help
        </div>

        <div class="cera-quick-buttons">

            <button
                type="button"
                class="cera-quick-button"
                data-question="How do I use CHAPERON?">

                Website Help

            </button>


            <button
                type="button"
                class="cera-quick-button"
                data-question="How can I know which approvals my business needs?">

                My Approvals

            </button>


            <button
                type="button"
                class="cera-quick-button"
                data-question="Where do I upload my documents in CHAPERON?">

                Documents

            </button>


            <button
                type="button"
                class="cera-quick-button"
                data-question="How can I check my application status and next step?">

                Application Help

            </button>


            <button
                type="button"
                class="cera-quick-button"
                data-question="How can CHAPERON help me manage compliance?">

                Compliance

            </button>

        </div>

    </div>


    <!-- ================================================= -->
    <!-- INPUT -->
    <!-- ================================================= -->

    <div class="cera-input-section">

        <div class="cera-input-box">

            <input
                id="ceraInput"
                type="text"
                maxlength="2000"
                autocomplete="off"
                placeholder="Ask CERA anything..."
            />


            <button
                id="ceraSendButton"
                type="button"
                title="Send">

                &#10148;

            </button>

        </div>

    </div>


    <!-- ================================================= -->
    <!-- DISCLAIMER -->
    <!-- ================================================= -->

    <div class="cera-disclaimer">

        CERA provides guidance based on information available in CHAPERON.
        It does not represent a government authority or guarantee approval.

    </div>

</div>


<script>

(function () {

    "use strict";


    var contextPath =
        "${pageContext.request.contextPath}";


    var ceraImagePath =
        contextPath
        + "/images/cera-logo.jpeg";


    var floatingButton =
        document.getElementById(
            "ceraFloatingButton"
        );


    var chatPanel =
        document.getElementById(
            "ceraChatPanel"
        );


    var closeButton =
        document.getElementById(
            "ceraCloseButton"
        );


    var input =
        document.getElementById(
            "ceraInput"
        );


    var sendButton =
        document.getElementById(
            "ceraSendButton"
        );


    var messages =
        document.getElementById(
            "ceraMessages"
        );


    if (
        floatingButton === null ||
        chatPanel === null ||
        closeButton === null ||
        input === null ||
        sendButton === null ||
        messages === null
    ) {

        return;
    }


    /* ==================================================
       OPEN / CLOSE
       ================================================== */


    floatingButton.addEventListener(
        "click",
        function () {

            chatPanel
                .classList
                .toggle(
                    "cera-open"
                );


            if (
                chatPanel
                    .classList
                    .contains(
                        "cera-open"
                    )
            ) {

                window.setTimeout(
                    function () {

                        input.focus();

                    },
                    150
                );
            }
        }
    );


    closeButton.addEventListener(
        "click",
        function () {

            chatPanel
                .classList
                .remove(
                    "cera-open"
                );
        }
    );


    /* ==================================================
       SEND
       ================================================== */


    sendButton.addEventListener(
        "click",
        function () {

            sendCeraMessage();
        }
    );


    input.addEventListener(
        "keydown",
        function (event) {

            if (
                event.key === "Enter"
            ) {

                event.preventDefault();

                sendCeraMessage();
            }
        }
    );


    /* ==================================================
       QUICK BUTTONS
       ================================================== */


    var quickButtons =
        document.querySelectorAll(
            ".cera-quick-button"
        );


    for (
        var i = 0;
        i < quickButtons.length;
        i++
    ) {

        quickButtons[i]
            .addEventListener(
                "click",
                function () {

                    var question =
                        this.getAttribute(
                            "data-question"
                        );


                    if (
                        question === null ||
                        question.trim() === ""
                    ) {

                        return;
                    }


                    input.value =
                        question;


                    sendCeraMessage();
                }
            );
    }


    /* ==================================================
       SEND TO SERVLET
       ================================================== */


    function sendCeraMessage() {

        var question =
            input.value.trim();


        if (
            question === ""
        ) {

            input.focus();

            return;
        }


        appendUserMessage(
            question
        );


        input.value =
            "";


        input.disabled =
            true;


        sendButton.disabled =
            true;


        var typingId =
            showTypingIndicator();


        var requestBody =
            "message="
            + encodeURIComponent(
                question
            );


        fetch(
            contextPath
            + "/cera/chat",
            {

                method:
                    "POST",

                headers: {

                    "Content-Type":
                        "application/x-www-form-urlencoded; charset=UTF-8"
                },

                body:
                    requestBody
            }
        )
        .then(
            function (response) {

                return response
                    .text()
                    .then(
                        function (responseText) {

                            if (
                                !response.ok
                            ) {

                                throw new Error(
                                    "CERA request failed"
                                );
                            }


                            try {

                                return JSON.parse(
                                    responseText
                                );

                            } catch (error) {

                                throw new Error(
                                    "Invalid CERA JSON"
                                );
                            }
                        }
                    );
            }
        )
        .then(
            function (data) {

                removeTypingIndicator(
                    typingId
                );


                var answer =
                    data.answer;


                if (
                    answer === null ||
                    answer === undefined ||
                    String(answer)
                        .trim() === ""
                ) {

                    answer =
                        "I could not generate a response. Please try again.";
                }


                appendBotMessage(
                    String(answer)
                );
            }
        )
        .catch(
            function () {

                removeTypingIndicator(
                    typingId
                );


                appendBotMessage(
                    "I am temporarily unable to respond. "
                    + "You can continue using CHAPERON manually "
                    + "and try asking me again."
                );
            }
        )
        .finally(
            function () {

                input.disabled =
                    false;


                sendButton.disabled =
                    false;


                input.focus();
            }
        );
    }


    /* ==================================================
       USER MESSAGE
       ================================================== */


    function appendUserMessage(
        text
    ) {

        var row =
            document.createElement(
                "div"
            );


        row.className =
            "cera-message-row cera-user-row";


        var bubble =
            document.createElement(
                "div"
            );


        bubble.className =
            "cera-message-bubble cera-user-bubble";


        bubble.textContent =
            text;


        row.appendChild(
            bubble
        );


        messages.appendChild(
            row
        );


        scrollToBottom();
    }


    /* ==================================================
       BOT MESSAGE
       ================================================== */


    function appendBotMessage(
        text
    ) {

        var row =
            document.createElement(
                "div"
            );


        row.className =
            "cera-message-row cera-bot-row";


        var logo =
            document.createElement(
                "img"
            );


        logo.src =
            ceraImagePath;


        logo.alt =
            "CERA";


        logo.className =
            "cera-mini-logo";


        var bubble =
            document.createElement(
                "div"
            );


        bubble.className =
            "cera-message-bubble cera-bot-bubble";


        bubble.textContent =
            text;


        row.appendChild(
            logo
        );


        row.appendChild(
            bubble
        );


        messages.appendChild(
            row
        );


        scrollToBottom();
    }


    /* ==================================================
       TYPING
       ================================================== */


    function showTypingIndicator() {

        var typingId =
            "ceraTyping_"
            + new Date()
                .getTime();


        var row =
            document.createElement(
                "div"
            );


        row.id =
            typingId;


        row.className =
            "cera-message-row cera-bot-row";


        var logo =
            document.createElement(
                "img"
            );


        logo.src =
            ceraImagePath;


        logo.alt =
            "CERA";


        logo.className =
            "cera-mini-logo";


        var bubble =
            document.createElement(
                "div"
            );


        bubble.className =
            "cera-message-bubble cera-bot-bubble";


        var typing =
            document.createElement(
                "div"
            );


        typing.className =
            "cera-typing-dots";


        var firstDot =
            document.createElement(
                "span"
            );


        var secondDot =
            document.createElement(
                "span"
            );


        var thirdDot =
            document.createElement(
                "span"
            );


        typing.appendChild(
            firstDot
        );


        typing.appendChild(
            secondDot
        );


        typing.appendChild(
            thirdDot
        );


        bubble.appendChild(
            typing
        );


        row.appendChild(
            logo
        );


        row.appendChild(
            bubble
        );


        messages.appendChild(
            row
        );


        scrollToBottom();


        return typingId;
    }


    function removeTypingIndicator(
        typingId
    ) {

        var typing =
            document.getElementById(
                typingId
            );


        if (
            typing !== null
        ) {

            typing.remove();
        }
    }


    /* ==================================================
       SCROLL
       ================================================== */


    function scrollToBottom() {

        messages.scrollTop =
            messages.scrollHeight;
    }

})();

</script>