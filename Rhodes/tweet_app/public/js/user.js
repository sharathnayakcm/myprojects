/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;

function validate_login(){
  var email = $.trim($("#username").val());
  var password = $.trim($("#password").val());

  var error_msg = '';
  var flag = true;
  
  if(email == ''){
    error_msg = 'Please enter username';
    flag = false;
  } else if(!regex.test(email)){
    error_msg = 'Please enter valid username/ email';
    flag = false;
  } else if(password == ''){
    error_msg = 'Please enter password';
    flag = false;
  }
  
  $(".errorMessage").html(error_msg);
return flag;
}

function validate_profile(){
  var first_name = $.trim($("#first_name").val());
  var last_name = $.trim($("#last_name").val());
  var email = $.trim($("#email").val());
  var password = $.trim($("#password").val());
  
  var error_msg = '';
  var flag = true;

  if(first_name == ''){
    error_msg = 'Please enter first name';
    flag = false;
  } else if(last_name == ''){
    error_msg = 'Please enter last name';
    flag = false;
  } else if(!regex.test(email)){
    error_msg = 'Please enter valid email';
    flag = false;
  } else if(password == ''){
    error_msg = 'Please enter password';
    flag = false;
  }

  $(".errorMessage").html(error_msg);
return flag;
}


