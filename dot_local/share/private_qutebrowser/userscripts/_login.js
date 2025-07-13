var forms = document.getElementsByTagName("form");

if("$(javascript_escape "${QUTE_URL}")" == window.location.href) {
    for (i = 0; i < forms.length; i++) {
        if (hasPasswordField(forms[i])) {
            loadData2Form(forms[i]);
        }
    }
} else {
    alert("Secrets will not be inserted.\nUrl of this page and the one where the user script was started differ.");
}

function hasPasswordField(form) {
    var inputs = form.getElementsByTagName("input");
    for (var j = 0; j < inputs.length; j++) {
        var input = inputs[j];
        if (input.type == "password") {
            return true;
        }
    }
    return false;
};

function loadData2Form (form) {
    var inputs = form.getElementsByTagName("input");
    for (var j = 0; j < inputs.length; j++) {
        var input = inputs[j];
        if (isVisible(input) && (input.type == "text" || input.type == "email")) {
            input.focus();
            input.value = "$(javascript_escape "${USERNAME}")";
            input.dispatchEvent(new Event('change'));
            input.blur();
        }
        if (input.type == "password") {
            input.focus();
            input.value = "$(javascript_escape "${PASSWORD}")";
            input.dispatchEvent(new Event('change'));
            input.blur();
        }
    }
};

function isVisible(elem) {
    var style = elem.ownerDocument.defaultView.getComputedStyle(elem, null);
    if (style.getPropertyValue("visibility") !== "visible" ||
        style.getPropertyValue("display") === "none" ||
        style.getPropertyValue("opacity") === "0") {
        return false;
    }
    return elem.offsetWidth > 0 && elem.offsetHeight > 0;
};
