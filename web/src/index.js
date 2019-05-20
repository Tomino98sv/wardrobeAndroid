firebase.auth().onAuthStateChanged(function(user) {
  if (user) {

    document.getElementById("user_div").style.display = "block";
    document.getElementById("login_div").style.display = "none";

    var user = firebase.auth().currentUser;

    if(user != null){

      var email_id = user.email;
      var email_verified = user.emailVerified;

      if(email_verified){
        document.getElementById("verify_btn").style.display = "none";
      } else {
        document.getElementById("verify_btn").style.display = "block";
      }

      document.getElementById("user_para").innerHTML = "Welcome user: " + email_id + "<br/> Verified: " + email_verified;

    }

  } else {

    document.getElementById("user_div").style.display = "none";
    document.getElementById("login_div").style.display = "block";

  }
});

function login(){

  var userEmail = document.getElementById("email_field").value;
  var userPass = document.getElementById("password_field").value;

  firebase.auth().signInWithEmailAndPassword(userEmail, userPass).catch(function(error) {
    var errorCode = error.code;
    var errorMessage = error.message;

    window.alert("Error : " + errorMessage);

  });

}

function create_account(){

  var userEmail = document.getElementById("email_field").value;
  var userPass = document.getElementById("password_field").value;

  firebase.auth().createUserWithEmailAndPassword(userEmail, userPass).catch(function(error) {
    var errorCode = error.code;
    var errorMessage = error.message;

    window.alert("Error : " + errorMessage);

  });

}

function logout(){
  firebase.auth().signOut();
}

function send_verification(){
  var user = firebase.auth().currentUser;
  user.sendEmailVerification().then(function(){
    window.alert("Verification was sent.");
  }).catch(function(error){
    window.alert("Error: " + error.message);
  });
}

function signInWithPopup() {
  console.log('ide?');
  var provider = new firebase.auth.GoogleAuthProvider();
  firebase.auth()
    .signInWithPopup(provider)
    .then(function(result) {
      console.log(result)
      var token = result.credential.accessToken;
      var user = result.user;
  }).catch(function(error) {
    console.log(error)
    var errorCode = error.code;
    var errorMessage = error.message;
    var email = error.email;
    var credential = error.credential;
  });

}


/*
firebase.auth().signInWithRedirect(provider);
firebase.auth().getRedirectResult().then(function(result) {
  if (result.credential) {
    var token = result.credential.accessToken;
  }
  var user = result.user;
}).catch(function(error) {
  var errorCode = error.code;
  var errorMessage = error.message;
  var email = error.email;
  var credential = error.credential;
});


firebase.auth().signOut().then(function() {
}).catch(function(error) {
});
*/
