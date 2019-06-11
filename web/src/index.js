var config = {
  apiKey: "AIzaSyBWJzCUQnWrgEf0rzsXrsIFRPhIp0N3tnc",
  authDomain: "wardrobe-26e92.firebaseapp.com",
  databaseURL: "https://wardrobe-26e92.firebaseio.com",
  projectId: "wardrobe-26e92",
  storageBucket: "wardrobe-26e92.appspot.com",
  messagingSenderId: "502526601242"
};
    firebase.initializeApp(config);

firebase.auth().onAuthStateChanged(function(user) {
  if (user) {
    document.getElementById("user_div").style.display = "block";
    document.getElementById("login_div").style.display = "none";
      var user = firebase.auth().currentUser;
      if (user != null) {
        var email_id = user.email;
        var email_verified = user.emailVerified;
      if (email_verified) {
        document.getElementById("verify_btn").style.display = "none";
      } else {
        document.getElementById("verify_btn").style.display = "block";
      }
      document.getElementById("user_para").innerHTML =
        "<h2>User email: </h2>" + email_id + "<br/><h2>Verified &nbsp;&nbsp;account: </h2>" + email_verified;
    }
  } else {
    document.getElementById("user_div").style.display = "none";
    document.getElementById("login_div").style.display = "block";
  }
});

function login() {
  var userEmail = document.getElementById("email_field").value;
  var userPass = document.getElementById("password_field").value;
  firebase
    .auth()
    .signInWithEmailAndPassword(userEmail, userPass)
    .catch(function(error) {
      var errorCode = error.code;
      var errorMessage = error.message;
        window.alert("Error : " + errorMessage);
    });
}

function create_account() {
  var userEmail = document.getElementById("email_field").value;
  var userPass = document.getElementById("password_field").value;
  firebase
    .auth()
    .createUserWithEmailAndPassword(userEmail, userPass)
    .catch(function(error) {
      var errorCode = error.code;
      var errorMessage = error.message;
        window.alert("Error : " + errorMessage);
    });
}

function logout() {
  firebase.auth().signOut();
}

function send_verification() {
  var user = firebase.auth().currentUser;
  user
    .sendEmailVerification()
    .then(function() {
      window.alert("A verification link has been sent to your email account.");
    })
    .catch(function(error) {
      window.alert("Error: " + error.message);
    });
}

function signInWithPopup() {
  console.log("It works?");
  var provider = new firebase.auth.GoogleAuthProvider();
  firebase
    .auth()
    .signInWithPopup(provider)
    .then(function(result) {
      console.log(result);
      var token = result.credential.accessToken;
      var user = result.user;
    })
    .catch(function(error) {
      console.log(error);
      var errorCode = error.code;
      var errorMessage = error.message;
      var email = error.email;
      var credential = error.credential;
    });
}
