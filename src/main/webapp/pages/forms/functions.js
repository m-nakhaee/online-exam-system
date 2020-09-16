
function loginIfUserAvailable() {
    let request = new XMLHttpRequest;
    request.open("Post", "login", true);
    request.setRequestHeader("Content-type", "application/json");
    request.dataType = "json";
    let user;
    user = {
        "email": document.getElementById("email").value,
        "password": document.getElementById("password").value,
    };
    let userString = JSON.stringify(user);
    request.send(userString);
    getResponse(request);
}

function getResponse(request) {
    request.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200)
            window.location.replace("userPanel");
        if (this.readyState === 4 && this.status !== 200)
            window.alert(this.response);
    }
}
