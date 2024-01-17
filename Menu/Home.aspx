<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Home.aspx.vb" Inherits="Home" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <!--estilo cabecero-->
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <!-- imagenes notificacionFontAwesome 4.3.0 -->
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <!-- Theme style -->
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <!-- AdminLTE Skins. Choose a skin from the css/skins
         folder instead of downloading all of them to reduce the load. -->
    <link href="../Content/form/css/skin-black.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/css/default.css" rel="stylesheet" type="text/css" />
    <link href="../Content/css/component.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Content/js/modernizr.custom.js"></script>
    <style type="text/css">
      /* reset */
* {
  margin: 0;
  padding: 0;
}


/* for show */
html, body {
  height: 100%;
}

body {
  background: rgba(10, 10, 113, 0.1) url("http://tympanus.net/Freebies/Boxify/img/hero-01.jpg") 50% 50%/cover;
}
</style>
</head>
<body>
       <form id="form1" runat="server">
         <nav class="navbar navbar-static-top" role="navigation">
            <!-- Sidebar toggle button-->
            <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
            </a>

          <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
              <!-- Notifications: style can be found in dropdown.less -->
              <li class="dropdown notifications-menu">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                  <i class="fa fa-bell-o"></i>
                  <span class="label label-warning"><%= nnot%></span>
                </a>
              </li>

              <!-- User Account: style can be found in dropdown.less -->
              <li class="dropdown user user-menu">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                  <img src="Content/form/img/incognito.jpg" class="user-image" 
                      alt="User Image" />
                  <span class="hidden-xs"><%= labeluser%></span>
                </a>
                <ul class="dropdown-menu">
                  <!-- User image -->
                  <li class="user-header">
                    <img src="Content/form/img/incognito.jpg" class="img-circle" alt="User Image" />
                    <p>
                      <%= labeludesc%>
                      <small><%= labeluant%></small>
                    </p>
                  </li>
                  <!-- Menu Body -->
                  <li class="user-footer">
                    <div class="pull-right">
                      <a href="#" class="btn btn-default btn-flat">Cerrar Sesion</a>
                    </div>
                  </li>
                </ul>
              </li>

            </ul>
          </div>

        </nav>
        <div id="princi" style="width: auto"> 


		<div class="container demo-3">	
			<!-- Codrops top bar -->
			<div class="codrops-top clearfix">
			</div><!--/ Codrops top bar -->
			<div class="main clearfix">
				<div class="column">
                    <h1 style="text-align: right">Grupo Batia Wep APP</h1>
                    <p>© 2015, Batia S.A. de C.V. </p>
                    <p>SINGA Version 15-01 </p>
      			</div>
				<div class="column">
					<div id="dl-menu" class="dl-menuwrapper">
						<button class="dl-trigger">Open Menu</button>
                                <%= labelmenu%>
					</div><!-- /dl-menuwrapper -->
				</div>
			</div>
		</div><!-- /container -->
        </div>

		<section  id="video">
			<div class="container">
				<div class="row">
					<div class="col-md-12 text-center">
						<h1><a href="https://www.youtube.com/embed/Qdb_AC4lGU8?autoplay=1&wmode=opaque&fs=1" class="youtube-media"><i class="fa fa-play-circle-o"></i> Video Corportivo</a></h1>
					</div>
				</div>
			</div>
		</section>



    <!-- jQuery 2.1.4 -->
    <script src="../Content/form/js/jQuery-2.1.4.min.js" type="text/javascript"></script>
        <!-- Bootstrap 3.3.2 JS -->
    <script src="../Content/form/js/bootstrap.min.js" type="text/javascript"></script>





        <script type="text/javascript" src="../Content/js/jquery.min.js"></script>
        <script type="text/javascript" src="../Content/js/jquery.dlmenu.js"></script>
        <script type="text/javascript">
            $(function () {
                $('#dl-menu').dlmenu({
                    animationClasses: { classin: 'dl-animate-in-5', classout: 'dl-animate-out-5' }
                });
            });
		</script>

    </form>

</body>
</html>
