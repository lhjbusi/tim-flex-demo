<%@ page language="java" pageEncoding="GB2312"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>index.jsp</title>
		<script type='text/javascript' src='/DWRTest/dwr/interface/Test.js'></script>		
		<script type='text/javascript' src='/DWRTest/dwr/engine.js'></script>
		<script type='text/javascript' src='/DWRTest/dwr/util.js'></script>
  		<script type="text/javascript">
  			function myTest(){
  				alert("aaaa");
  				Test.getValues("aaaaa", function(data){
  					alert(data);
  				});
  			}
  		</script>
	</head>

	<body>
		<input name="userName">
		<button onclick="myTest();">
			Submit
		</button>
	</body>
</html>
