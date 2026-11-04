/**
 * Modern LMS Quiz Assessment Controller
 * Handles live countdown timer, single-question paging, progress bar,
 * option selection, and right sidebar palette synchronization.
 */

var QuizController = (function() {
    var totalQuestions = 0;
    var currentIndex = 0;
    var remainingSeconds = 0;
    var elapsedSeconds = 0;
    var timerInterval = null;
    var formEl = null;
    var timerEl = null;
    var timeTakenInput = null;
    var progressBar = null;
    var questionCounterEl = null;
    var prevBtn = null;
    var nextBtn = null;
    var isSubmitted = false;

    function init(config) {
        totalQuestions = config.totalQuestions;
        remainingSeconds = config.totalSeconds;
        formEl = document.getElementById(config.formId);
        timerEl = document.getElementById(config.timerDisplayId);
        timeTakenInput = document.getElementById('timeTakenInput');
        progressBar = document.getElementById('quizProgressBar');
        questionCounterEl = document.getElementById('questionCounterText');
        prevBtn = document.getElementById('btnPrevQuestion');
        nextBtn = document.getElementById('btnNextQuestion');

        // Setup timer
        startTimer();

        // Setup navigation buttons
        if (prevBtn) {
            prevBtn.addEventListener('click', function() {
                if (currentIndex > 0) {
                    goToQuestion(currentIndex - 1);
                }
            });
        }

        if (nextBtn) {
            nextBtn.addEventListener('click', function() {
                if (currentIndex < totalQuestions - 1) {
                    goToQuestion(currentIndex + 1);
                } else {
                    submitQuiz(false);
                }
            });
        }

        // Setup option selection click events
        setupOptionClicks();

        // Setup palette clicks
        setupPaletteClicks();

        // Initial view setup
        goToQuestion(0);

        // Prevent accidental tab close
        window.addEventListener('beforeunload', function(e) {
            if (!isSubmitted && remainingSeconds > 0) {
                e.preventDefault();
                e.returnValue = 'You have an active quiz session in progress. Leaving will lose your responses.';
            }
        });
    }

    function startTimer() {
        updateTimerDisplay();
        timerInterval = setInterval(function() {
            remainingSeconds--;
            elapsedSeconds++;
            if (timeTakenInput) {
                timeTakenInput.value = elapsedSeconds;
            }

            if (remainingSeconds <= 0) {
                clearInterval(timerInterval);
                submitQuiz(true);
                return;
            }

            updateTimerDisplay();
        }, 1000);
    }

    function updateTimerDisplay() {
        if (!timerEl) return;
        var minutes = Math.floor(remainingSeconds / 60);
        var seconds = remainingSeconds % 60;
        var formatted = minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
        timerEl.textContent = formatted;

        // Visual alert when less than 60 seconds
        var pill = timerEl.closest('.lms-timer-pill');
        if (pill) {
            if (remainingSeconds <= 60) {
                pill.classList.add('urgent');
            } else {
                pill.classList.remove('urgent');
            }
        }
    }

    function goToQuestion(index) {
        currentIndex = index;

        // Hide all question cards, show current
        var allCards = document.querySelectorAll('.question-step-card');
        allCards.forEach(function(card, idx) {
            if (idx === currentIndex) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });

        // Update progress bar
        if (progressBar) {
            var percent = Math.round(((currentIndex + 1) / totalQuestions) * 100);
            progressBar.style.width = percent + '%';
        }

        // Update question counter text
        if (questionCounterEl) {
            questionCounterEl.textContent = "Question " + (currentIndex + 1) + " of " + totalQuestions;
        }

        // Update Previous Button
        if (prevBtn) {
            if (currentIndex === 0) {
                prevBtn.style.visibility = 'hidden';
            } else {
                prevBtn.style.visibility = 'visible';
            }
        }

        // Update Next / Submit Button
        if (nextBtn) {
            if (currentIndex === totalQuestions - 1) {
                nextBtn.innerHTML = 'Submit Assessment &#10003;';
                nextBtn.className = 'btn btn-success btn-lg';
            } else {
                nextBtn.innerHTML = 'Next Question &rarr;';
                nextBtn.className = 'btn btn-primary btn-lg';
            }
        }

        // Update Palette current state
        updatePaletteStatus();
    }

    function setupOptionClicks() {
        var optionCards = document.querySelectorAll('.lms-option-card');
        optionCards.forEach(function(card) {
            card.addEventListener('click', function() {
                var radio = this.querySelector('input[type="radio"]');
                if (radio) {
                    radio.checked = true;

                    // Unselect other siblings in same question
                    var qCard = this.closest('.question-step-card');
                    var siblingCards = qCard.querySelectorAll('.lms-option-card');
                    siblingCards.forEach(function(c) {
                        c.classList.remove('selected');
                    });

                    this.classList.add('selected');
                    updatePaletteStatus();
                }
            });
        });
    }

    function setupPaletteClicks() {
        var paletteBtns = document.querySelectorAll('.palette-btn');
        paletteBtns.forEach(function(btn) {
            btn.addEventListener('click', function() {
                var qIdx = parseInt(this.getAttribute('data-index'), 10);
                if (!isNaN(qIdx)) {
                    goToQuestion(qIdx);
                }
            });
        });
    }

    function updatePaletteStatus() {
        var paletteBtns = document.querySelectorAll('.palette-btn');
        var allCards = document.querySelectorAll('.question-step-card');

        paletteBtns.forEach(function(btn, idx) {
            btn.classList.remove('current', 'answered');

            // Check if answered
            var qCard = allCards[idx];
            if (qCard) {
                var isChecked = qCard.querySelector('input[type="radio"]:checked');
                if (isChecked) {
                    btn.classList.add('answered');
                }
            }

            // Current question indicator
            if (idx === currentIndex) {
                btn.classList.add('current');
            }
        });
    }

    function submitQuiz(isAuto) {
        if (isSubmitted) return;

        if (isAuto) {
            alert("Time's up! Your assessment is being submitted automatically.");
            isSubmitted = true;
            formEl.submit();
            return;
        }

        var answeredCount = document.querySelectorAll('input[type="radio"]:checked').length;
        var confirmMsg = "Are you sure you want to finish and submit this quiz?";
        if (answeredCount < totalQuestions) {
            confirmMsg = "You have answered " + answeredCount + " of " + totalQuestions + " questions (" + (totalQuestions - answeredCount) + " unanswered).\n\nDo you want to submit anyway?";
        }

        if (confirm(confirmMsg)) {
            isSubmitted = true;
            formEl.submit();
        }
    }

    return {
        init: init,
        goToQuestion: goToQuestion,
        submitQuiz: submitQuiz
    };
})();
