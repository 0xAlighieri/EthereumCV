// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";
import 'bootstrap/dist/css/bootstrap.css';


// Import libraries we need.
import { default as Web3 } from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import resume_artifacts from '../../build/contracts/Resume.json';

// MetaCoin is our usable abstraction, which we'll use through the code below.
var Resume = contract(resume_artifacts);

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;

window.App = {
  start: function () {
    var self = this;

    // Bootstrap the MetaCoin abstraction for Use.
    Resume.setProvider(web3.currentProvider);

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length === 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      account = accounts[0];
    });

    this.getTitle();
    this.getAuthor();
  },

  getTitle: function() {
    var self = this;

    Resume.deployed().then(function(instance) {
      return instance.getTitle.call();
    }).then(function(value) {
      document.getElementById("title").innerHTML = value;
    }).catch(function(e) {
      console.log(e);
    });
  },
  getAuthor: function() {
      var self = this;
  
      Resume.deployed().then(function(instance) {
        return instance.getAuthor.call();
      }).then(function(value) {
        console.log(value);
        const author = value[0];
        const email = value[1];
        document.getElementById("author").innerHTML = author;
        document.getElementById("email").innerHTML = email;
      }).catch(function(e) {
        console.log(e);
      });
  },
};

window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
  } else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  }

  App.start();
});
