CREATE PROCEDURE [dbo].[Marker248]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

	  MERGE INTO [dbo].[HtmlTemplates] AS Target 
			USING ( VALUES 
	(N'RemoteSiteCompanyRegistrationTemplate',
			'<!doctype html>
	<html lang="en">
	  <head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta name="x-apple-disable-message-reformatting">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>Account Addons</title>
		<style type="text/css">
		  a { text-decoration: none; outline: none; }
		  @media (max-width: 649px) {
			.o_col-full { max-width: 100% !important; }
			.o_col-half { max-width: 50% !important; }
			.o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important; overflow: visible !important; width: auto !important; visibility: visible !important; }
			.o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }
			.o_xs-center { text-align: center !important; }
			.o_xs-left { text-align: left !important; }
			.o_xs-right { text-align: left !important; }
			table.o_xs-left { margin-left: 0 !important; margin-right: auto !important; float: none !important; }
			table.o_xs-right { margin-left: auto !important; margin-right: 0 !important; float: none !important; }
			table.o_xs-center { margin-left: auto !important; margin-right: auto !important; float: none !important; }
			h1.o_heading { font-size: 32px !important; line-height: 41px !important; }
			h2.o_heading { font-size: 26px !important; line-height: 37px !important; }
			h3.o_heading { font-size: 20px !important; line-height: 30px !important; }
			.o_xs-py-md { padding-top: 24px !important; padding-bottom: 24px !important; }
			.o_xs-pt-xs { padding-top: 8px !important; }
			.o_xs-pb-xs { padding-bottom: 8px !important; }
		  }
		  @media screen {
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 400;
			  src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
			  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 400;
			  src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
			  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 700;
			  src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
			  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 700;
			  src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
			  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
			.o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }
			.o_heading, strong, b { font-weight: 700 !important; }
			a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }
		  }
		</style>
		<!--[if mso]>
		<style>
		  table { border-collapse: collapse; }
		  .o_col { float: left; }
		</style>
		<xml>
		  <o:OfficeDocumentSettings>
			<o:PixelsPerInch>96</o:PixelsPerInch>
		  </o:OfficeDocumentSettings>
		</xml>
		<![endif]-->
	  </head>
	  <body class="o_body o_bg-light" style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
		<!-- preview-text -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_hide" align="center" style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">Email Summary (Hidden)</td>
			</tr>
		  </tbody>
		</table>
		<!-- header-primary-button -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_re o_bg-primary o_px o_pb-md o_br-t" align="center" style="font-size: 0;vertical-align: top;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-bottom: 24px;">
						<!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="200" align="left" valign="top" style="padding:0px 8px;"><![endif]-->
						<div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
						  <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
						  <div class="o_px-xs o_sans o_text o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;text-align: left;padding-left: 8px;padding-right: 8px;">
							<p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white" style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyRegistrationLogo##" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
						  </div>
						</div>
						<!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->
						<div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
						  <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
						  <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
							<table class="o_right o_xs-center" cellspacing="0" cellpadding="0" border="0" role="presentation" style="text-align: right;margin-left: auto;margin-right: 0;">
							  <!-- <tbody> -->
								<!-- <tr> -->
								  <!-- <td class="o_btn-xs o_bg-white o_br o_heading o_text-xs" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;mso-padding-alt: 7px 16px;background-color: #ffffff;border-radius: 4px;"> -->
									<!-- <a class="o_text-primary" href="https://example.com/" style="text-decoration: none;outline: none;color: #126de5;display: block;padding: 7px 16px;mso-text-raise: 3px;">Get the App</a> -->
								  <!-- </td> -->
								<!-- </tr> -->
							  <!-- </tbody> -->
							</table>
						  </div>
						</div>
						<!--[if mso]></td></tr></table><![endif]-->
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- hero-primary -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-primary o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-white" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #126de5;color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
						<h1 class="o_heading o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;font-size: 36px;line-height: 47px;">Thank you and congratulations for choosing Snovasys Remote Working Software</h1>
						<p style="margin-top: 0px;margin-bottom: 0px;">We are really excited you''ve joined Snovasys Remote Working Software.</p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- spacer -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- content-lg -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<h4 class="o_heading o_text-dark o_mb-xs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 8px;color: #242b3d;font-size: 18px;line-height: 23px;">Your Account Details</h4>
						<p style="margin-top: 0px;margin-bottom: 0px;">We are here to help you get started with this software. Many people use this software to track their productivity, so you''re in great company. To get the most out of your free trial, take a minute to set up your account and to start tracking your productivity.</p>
					  </td>
					</tr>
					 <tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p style="margin-top: 0px;margin-bottom: 0px;">Please click the following link on your browser to access the application.</p>
						<p style="margin-top: 0px;margin-bottom: 0px;">
						<a target="_blank" href="##siteAddress##" style="color:#5fb92a;font-weight:bold;text-decoration:underline" >Snovasys Remote Working Software Link</a>
						</p>
					  </td>
					</tr> 
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- label-xs -->
	
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text-xs o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p class="o_mb" style="margin-top: 0px;margin-bottom: 16px;"><strong>Username</strong></p>
						<table role="presentation" cellspacing="0" cellpadding="0" border="0">
						  <tbody>
							<tr>
							  <td width="284" class="o_bg-ultra_light o_br o_text-xs o_sans o_px-xs o_py" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ebf5fa;border-radius: 4px;padding-left: 8px;padding-right: 8px;padding-top: 16px;padding-bottom: 16px;">
								<p class="o_text-dark" style="color: #242b3d;margin-top: 0px;margin-bottom: 0px;"><strong>##userName##</strong></p>
							  </td>
							</tr>
						  </tbody>
						</table>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- label-xs -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text-xs o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p class="o_mb" style="margin-top: 0px;margin-bottom: 16px;"><strong>Password</strong></p>
						<table role="presentation" cellspacing="0" cellpadding="0" border="0">
						  <tbody>
							<tr>
							  <td width="284" class="o_bg-ultra_light o_br o_text-xs o_sans o_px-xs o_py" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ebf5fa;border-radius: 4px;padding-left: 8px;padding-right: 8px;padding-top: 16px;padding-bottom: 16px;">
								<p class="o_text-dark" style="color: #242b3d;margin-top: 0px;margin-bottom: 0px;"><strong>##password##</strong></p>
							  </td>
							</tr>
						  </tbody>
						</table>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
	
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>               
					 <tr>
					  <td style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;">
					  <ul>
						  <li><p><em></em><a target="_blank" href="##chatApllication##" style="color:#5fb92a;font-weight:bold;text-decoration:underline">Snovasys Remote Working Desktop Tool</a> As needed, you could install a light weight tool on your computer to help tracking, messaging purposes. Please click here or paste this link in your browser.</p></li>
						  <li><p><em></em><a target="_blank" href="##guidelink##" style="color:#5fb92a;font-weight:bold;text-decoration:underline">Snovasys Remote Working User Guide</a> You could also access our user guide by clicking on this link.</p></li> 
					  </ul>
					  </td>
					</tr> 				
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
	
		 <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
					  <p style= "font-size:small"><img goomoji="23f0" data-goomoji="23f0" style="margin:0 0.2ex;vertical-align:middle;max-height:18px" alt="⏰" src="https://mail.google.com/mail/e/23f0" data-image-whitelisted="" class="CToWUd">Kick off your free trial by quickly setting everything up. Watch our 2 min tutorial video.</p>
						<iframe width="500" height="250" src="https://www.youtube.com/embed/5DdFUtuL5fw" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe> 
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
	
   
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p style="margin-top: 0px;margin-bottom: 0px;">Thank you again for your registration and all the very best. For further queries, please reach out to your dedicated account manager and our Whatsapp number (0044-7944144944).</p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- spacer-lg -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white" style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp; </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- footer -->
	   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center" style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
						<div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
						  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
						  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
							<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights reserved</p>
						<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944    - info@snovasys.com</p>
						<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road London - TW4 6JQ</p>
						<p style="margin-top: 0px;margin-bottom: 0px;">
							  Learn more at <a class="o_text-dark_light o_underline" href=##Registersite## style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> 
						  </p>
						  </div>
						</div>
						<!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->
						<div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
						  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
						  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
							<p style="margin-top: 0px;margin-bottom: 0px;">
							  <a class="o_text-dark_light" href="https://www.facebook.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=68BE1104-6486-4C48-92CE-51655C220EC8" width="36" height="36" alt="fb" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							  <a class="o_text-dark_light" href="https://twitter.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=724466D8-BC90-4747-A28D-18D810516738" width="36" height="36" alt="tw" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							  <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F23ACFD-6145-4431-B55A-E117BBF8AD4C" width="36" height="36" alt="ig" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							</p>
						  </div>
						</div>
					   </td>
					</tr>
				  </tbody>
				</table>
	  </body>
	</html>',@CompanyId),
	(N'CompanyRegistrationTemplate',
			'<!doctype html>
	<html lang="en">
	  <head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta name="x-apple-disable-message-reformatting">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>Account Addons</title>
		<style type="text/css">
		  a { text-decoration: none; outline: none; }
		  @media (max-width: 649px) {
			.o_col-full { max-width: 100% !important; }
			.o_col-half { max-width: 50% !important; }
			.o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important; overflow: visible !important; width: auto !important; visibility: visible !important; }
			.o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }
			.o_xs-center { text-align: center !important; }
			.o_xs-left { text-align: left !important; }
			.o_xs-right { text-align: left !important; }
			table.o_xs-left { margin-left: 0 !important; margin-right: auto !important; float: none !important; }
			table.o_xs-right { margin-left: auto !important; margin-right: 0 !important; float: none !important; }
			table.o_xs-center { margin-left: auto !important; margin-right: auto !important; float: none !important; }
			h1.o_heading { font-size: 32px !important; line-height: 41px !important; }
			h2.o_heading { font-size: 26px !important; line-height: 37px !important; }
			h3.o_heading { font-size: 20px !important; line-height: 30px !important; }
			.o_xs-py-md { padding-top: 24px !important; padding-bottom: 24px !important; }
			.o_xs-pt-xs { padding-top: 8px !important; }
			.o_xs-pb-xs { padding-bottom: 8px !important; }
		  }
		  @media screen {
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 400;
			  src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
			  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 400;
			  src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
			  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 700;
			  src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
			  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 700;
			  src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
			  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
			.o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }
			.o_heading, strong, b { font-weight: 700 !important; }
			a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }
		  }
		</style>
		<!--[if mso]>
		<style>
		  table { border-collapse: collapse; }
		  .o_col { float: left; }
		</style>
		<xml>
		  <o:OfficeDocumentSettings>
			<o:PixelsPerInch>96</o:PixelsPerInch>
		  </o:OfficeDocumentSettings>
		</xml>
		<![endif]-->
	  </head>
	  <body class="o_body o_bg-light" style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
		<!-- preview-text -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_hide" align="center" style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">Email Summary (Hidden)</td>
			</tr>
		  </tbody>
		</table>
		<!-- header-primary-button -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_re o_bg-primary o_px o_pb-md o_br-t" align="center" style="font-size: 0;vertical-align: top;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-bottom: 24px;">
						<!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="200" align="left" valign="top" style="padding:0px 8px;"><![endif]-->
						<div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
						  <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
						  <div class="o_px-xs o_sans o_text o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;text-align: left;padding-left: 8px;padding-right: 8px;">
							<p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white" style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyRegistrationLogo##" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
						  </div>
						</div>
						<!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->
						<div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
						  <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
						  <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
							<table class="o_right o_xs-center" cellspacing="0" cellpadding="0" border="0" role="presentation" style="text-align: right;margin-left: auto;margin-right: 0;">
							  <!-- <tbody> -->
								<!-- <tr> -->
								  <!-- <td class="o_btn-xs o_bg-white o_br o_heading o_text-xs" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;mso-padding-alt: 7px 16px;background-color: #ffffff;border-radius: 4px;"> -->
									<!-- <a class="o_text-primary" href="https://example.com/" style="text-decoration: none;outline: none;color: #126de5;display: block;padding: 7px 16px;mso-text-raise: 3px;">Get the App</a> -->
								  <!-- </td> -->
								<!-- </tr> -->
							  <!-- </tbody> -->
							</table>
						  </div>
						</div>
						<!--[if mso]></td></tr></table><![endif]-->
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- hero-primary -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-primary o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-white" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #126de5;color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
						<h1 class="o_heading o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;font-size: 36px;line-height: 47px;">Thank you and congratulations for choosing Snovasys Business Suite to grow your business</h1>
						<p style="margin-top: 0px;margin-bottom: 0px;">We are really excited you''ve joined Snovasys Business Suite Software.</p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- spacer -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- content-lg -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<h4 class="o_heading o_text-dark o_mb-xs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 8px;color: #242b3d;font-size: 18px;line-height: 23px;">Your Account Details</h4>
						<p style="margin-top: 0px;margin-bottom: 0px;">We are here to help you get started with this software. Many people use this software, so you''re in great company. To get the most out of your free trial, take a minute to set up your account and to start using this software.</p>
					  </td>
					</tr>
					 <tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p style="margin-top: 0px;margin-bottom: 0px;">Please click the following link on your browser to access the application.</p>
						<p style="margin-top: 0px;margin-bottom: 0px;">
						<a target="_blank" href="##siteAddress##" style="color:#5fb92a;font-weight:bold;text-decoration:underline" >Site Link</a>
						</p>
					  </td>
					</tr> 
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- label-xs -->
	
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text-xs o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p class="o_mb" style="margin-top: 0px;margin-bottom: 16px;"><strong>Username</strong></p>
						<table role="presentation" cellspacing="0" cellpadding="0" border="0">
						  <tbody>
							<tr>
							  <td width="284" class="o_bg-ultra_light o_br o_text-xs o_sans o_px-xs o_py" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ebf5fa;border-radius: 4px;padding-left: 8px;padding-right: 8px;padding-top: 16px;padding-bottom: 16px;">
								<p class="o_text-dark" style="color: #242b3d;margin-top: 0px;margin-bottom: 0px;"><strong>##userName##</strong></p>
							  </td>
							</tr>
						  </tbody>
						</table>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- label-xs -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text-xs o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p class="o_mb" style="margin-top: 0px;margin-bottom: 16px;"><strong>Password</strong></p>
						<table role="presentation" cellspacing="0" cellpadding="0" border="0">
						  <tbody>
							<tr>
							  <td width="284" class="o_bg-ultra_light o_br o_text-xs o_sans o_px-xs o_py" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ebf5fa;border-radius: 4px;padding-left: 8px;padding-right: 8px;padding-top: 16px;padding-bottom: 16px;">
								<p class="o_text-dark" style="color: #242b3d;margin-top: 0px;margin-bottom: 0px;"><strong>##password##</strong></p>
							  </td>
							</tr>
						  </tbody>
						</table>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
	
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>               
					 <tr>
					  <td style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;">
					  <ul>
						  <li><p><em></em><a target="_blank" href="https://snovasys.com/Documents/SnovasysTerms.pdf" style="color:#5fb92a;font-weight:bold;text-decoration:underline">Terms and Conditions</a> Please go through this link and find the terms and conditions of Snovasys Business Suite.</p></li>				     
					  </ul>
					  </td>
					</tr> 				
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p style="margin-top: 0px;margin-bottom: 0px;">Thank you again for your registration and all the very best. For further queries, please reach out to your dedicated account manager and our Whatsapp number (0044-7944144944).</p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- spacer-lg -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white" style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp; </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- footer -->
	   <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center" style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
						<div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
						  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
						  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
							<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights reserved</p>
						<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944    - info@snovasys.com</p>
						<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road London - TW4 6JQ</p>
						<p style="margin-top: 0px;margin-bottom: 0px;">
							  Learn more at <a class="o_text-dark_light o_underline" href=##Registersite## style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> 
						  </p>
						  </div>
						</div>
						<!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->
						<div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
						  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
						  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
							<p style="margin-top: 0px;margin-bottom: 0px;">
							  <a class="o_text-dark_light" href="https://www.facebook.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=68BE1104-6486-4C48-92CE-51655C220EC8" width="36" height="36" alt="fb" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							  <a class="o_text-dark_light" href="https://twitter.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=724466D8-BC90-4747-A28D-18D810516738" width="36" height="36" alt="tw" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							  <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F23ACFD-6145-4431-B55A-E117BBF8AD4C" width="36" height="36" alt="ig" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							</p>
						  </div>
						</div>
					   </td>
					</tr>
				  </tbody>
				</table>
	  </body>
	</html>',@CompanyId),
	(N'ResetPasswordTemplate',
			'<!doctype html>
	<html lang="en">
	  <head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta name="x-apple-disable-message-reformatting">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>Account Password Reset</title>
		<style type="text/css">
		  a { text-decoration: none; outline: none; }
		  @media (max-width: 649px) {
			.o_col-full { max-width: 100% !important; }
			.o_col-half { max-width: 50% !important; }
			.o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important; overflow: visible !important; width: auto !important; visibility: visible !important; }
			.o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }
			.o_xs-center { text-align: center !important; }
			.o_xs-left { text-align: left !important; }
			.o_xs-right { text-align: left !important; }
			table.o_xs-left { margin-left: 0 !important; margin-right: auto !important; float: none !important; }
			table.o_xs-right { margin-left: auto !important; margin-right: 0 !important; float: none !important; }
			table.o_xs-center { margin-left: auto !important; margin-right: auto !important; float: none !important; }
			h1.o_heading { font-size: 32px !important; line-height: 41px !important; }
			h2.o_heading { font-size: 26px !important; line-height: 37px !important; }
			h3.o_heading { font-size: 20px !important; line-height: 30px !important; }
			.o_xs-py-md { padding-top: 24px !important; padding-bottom: 24px !important; }
			.o_xs-pt-xs { padding-top: 8px !important; }
			.o_xs-pb-xs { padding-bottom: 8px !important; }
		  }
		  @media screen {
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 400;
			  src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
			  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 400;
			  src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
			  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 700;
			  src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
			  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 700;
			  src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
			  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
			.o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }
			.o_heading, strong, b { font-weight: 700 !important; }
			a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }
		  }
		</style>
		<!--[if mso]>
		<style>
		  table { border-collapse: collapse; }
		  .o_col { float: left; }
		</style>
		<xml>
		  <o:OfficeDocumentSettings>
			<o:PixelsPerInch>96</o:PixelsPerInch>
		  </o:OfficeDocumentSettings>
		</xml>
		<![endif]-->
	  </head>
	  <body class="o_body o_bg-light" style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
		<!-- preview-text -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_hide" align="center" style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">Email Summary (Hidden)</td>
			</tr>
		  </tbody>
		</table>
		<!-- header-white-link -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_re o_bg-white o_px o_pb-md o_br-t" align="center" style="font-size: 0;vertical-align: top;background-color: #ffffff;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-bottom: 24px;">
						<!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="200" align="left" valign="top" style="padding:0px 8px;"><![endif]-->
						<div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
						  <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
						  <div class="o_px-xs o_sans o_text o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;text-align: left;padding-left: 8px;padding-right: 8px;">
							<p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-primary" style="text-decoration: none;outline: none;color: #126de5;"><img src=##CompanyLogo## width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
						  </div>
						</div>
						<!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->
						<div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
						  <div style="font-size: 22px; line-height: 22px; height: 22px;">&nbsp; </div>
						  <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
							<table class="o_right o_xs-center" cellspacing="0" cellpadding="0" border="0" role="presentation" style="text-align: right;margin-left: auto;margin-right: 0;">
							  <tbody>
								<tr>
								  <td class="o_btn-b o_heading o_text-xs" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;mso-padding-alt: 7px 8px;">
									<a class="o_text-light" style="text-decoration: none;outline: none;color: #82899a;display: block;padding: 7px 8px;font-weight: bold;"><span style="mso-text-raise: 6px;display: inline;color: #82899a;">##userName## </span> <img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=17968836-9C13-4A7B-97C5-AF198C4BD3D6" width="24" height="24" alt="" style="max-width: 24px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
								  </td>
								</tr>
							  </tbody>
							</table>
						  </div>
						</div>
						<!--[if mso]></td></tr></table><![endif]-->
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- hero-icon-lines -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-ultra_light o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ebf5fa;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
						<table role="presentation" cellspacing="0" cellpadding="0" border="0">
						  <tbody>
							<tr>
							  <td class="o_bb-primary" height="40" width="32" style="border-bottom: 1px solid #126de5;">&nbsp; </td>
							  <td rowspan="2" class="o_sans o_text o_text-secondary o_px o_py" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
								<img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2FFE10BE-B337-46F8-AFCB-9F899DC850B6" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
							  </td>
							  <td class="o_bb-primary" height="40" width="32" style="border-bottom: 1px solid #126de5;">&nbsp; </td>
							</tr>
							<tr>
							  <td height="40">&nbsp; </td>
							  <td height="40">&nbsp; </td>
							</tr>
							<tr>
							  <td style="font-size: 8px; line-height: 8px; height: 8px;">&nbsp; </td>
							  <td style="font-size: 8px; line-height: 8px; height: 8px;">&nbsp; </td>
							</tr>
						  </tbody>
						</table>
						<h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">Forgot Your Password?</h2>
						<p style="margin-top: 0px;margin-bottom: 0px;">Protecting your data is important to us.</p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- spacer -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- content -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p style="margin-top: 0px;margin-bottom: 0px;">We''re sending you this email because you requested a password reset for your account. Please reset your password by clicking on the below button.</p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- button-primary -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
						<table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
						  <tbody>
							<tr>
							  <td width="300" class="o_btn o_bg-primary o_br o_heading o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #126de5;border-radius: 4px;">
								<a class="o_text-white" href="##resetPasswordLink##" style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">Reset My Password</a>
							  </td>
							</tr>
						  </tbody>
						</table>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		 <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p style="margin-top: 0px;margin-bottom: 0px;">If you didn''t request a password reset, you can ignore this email.</p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- spacer-lg -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white" style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp; </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- footer-white-2cols -->
		<table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center" style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
						<div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
						  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
						  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
							<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights reserved</p>
						<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944    - info@snovasys.com</p>
						<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road London - TW4 6JQ</p>
						<p style="margin-top: 0px;margin-bottom: 0px;">
							  Learn more at <a class="o_text-dark_light o_underline" href=##Registersite## style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> 
						  </p>
						  </div>
						</div>
						<!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->
						<div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
						  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
						  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
							<p style="margin-top: 0px;margin-bottom: 0px;">
							  <a class="o_text-dark_light" href="https://www.facebook.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=68BE1104-6486-4C48-92CE-51655C220EC8" width="36" height="36" alt="fb" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							  <a class="o_text-dark_light" href="https://twitter.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=724466D8-BC90-4747-A28D-18D810516738" width="36" height="36" alt="tw" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							  <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F23ACFD-6145-4431-B55A-E117BBF8AD4C" width="36" height="36" alt="ig" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							</p>
						  </div>
						</div>
					   </td>
					</tr>
				  </tbody>
				</table>
	  </body>
	</html>',@CompanyId),
	(N'UserRegistrationNotificationTemplate',
			'<!doctype html>
	<html lang="en">
	  <head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta name="x-apple-disable-message-reformatting">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>Account New Sign-in</title>
		<style type="text/css">
		  a { text-decoration: none; outline: none; }
		  @media (max-width: 649px) {
			.o_col-full { max-width: 100% !important; }
			.o_col-half { max-width: 50% !important; }
			.o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important; overflow: visible !important; width: auto !important; visibility: visible !important; }
			.o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }
			.o_xs-center { text-align: center !important; }
			.o_xs-left { text-align: left !important; }
			.o_xs-right { text-align: left !important; }
			table.o_xs-left { margin-left: 0 !important; margin-right: auto !important; float: none !important; }
			table.o_xs-right { margin-left: auto !important; margin-right: 0 !important; float: none !important; }
			table.o_xs-center { margin-left: auto !important; margin-right: auto !important; float: none !important; }
			h1.o_heading { font-size: 32px !important; line-height: 41px !important; }
			h2.o_heading { font-size: 26px !important; line-height: 37px !important; }
			h3.o_heading { font-size: 20px !important; line-height: 30px !important; }
			.o_xs-py-md { padding-top: 24px !important; padding-bottom: 24px !important; }
			.o_xs-pt-xs { padding-top: 8px !important; }
			.o_xs-pb-xs { padding-bottom: 8px !important; }
		  }
		  @media screen {
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 400;
			  src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
			  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 400;
			  src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
			  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 700;
			  src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
			  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 700;
			  src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
			  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
			.o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }
			.o_heading, strong, b { font-weight: 700 !important; }
			a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }
		  }
		</style>
		<!--[if mso]>
		<style>
		  table { border-collapse: collapse; }
		  .o_col { float: left; }
		</style>
		<xml>
		  <o:OfficeDocumentSettings>
			<o:PixelsPerInch>96</o:PixelsPerInch>
		  </o:OfficeDocumentSettings>
		</xml>
		<![endif]-->
	  </head>
	  <body class="o_body o_bg-light" style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
		<!-- preview-text -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_hide" align="center" style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">Email Summary (Hidden)</td>
			</tr>
		  </tbody>
		</table>
		<!-- header-primary -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
						<p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white" style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyRegistrationLogo##" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- hero-white-icon-outline -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
						<table cellspacing="0" cellpadding="0" border="0" role="presentation">
						  <tbody>
							<tr>
							  <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
								<img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=138EB53F-BAF9-44A8-9DDB-F26FA43D84B9" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
							  </td>
							</tr>
							<tr>
							  <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
							</tr>
						  </tbody>
						</table>
						<h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">You''ve Been Invited</h2>
						<p style="margin-top: 0px;margin-bottom: 0px;">Welcome to ##CompanyName##!</p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- device-row -->
    
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>               
					 <tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						 <div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">
						  <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
							<tbody>
							  <tr>
								<td class="o_re o_bt-light" style="font-size: 16px;line-height: 16px;height: 16px;vertical-align: top;border-top: 1px solid #d3dce0;">&nbsp; </td>
							  </tr>
							</tbody>
						  </table>
						</div>
					   <p style="margin-top: 0px;margin-bottom: 0px;">We are pleased to have you joining our team. Are you ready to fall in love with your new job and meet your great new colleagues.</p>
						</p>
					  </td>
					</tr> 
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>               
					 <tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">		   
						<p style="margin-top: 0px;margin-bottom: 0px;">Please click the following link on your browser to join us.</p>					
					  </td>
					</tr> 
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py-xs" align="center" style="background-color: #ffffff;padding-left: 24px;padding-right: 24px;padding-top: 8px;padding-bottom: 8px;">
						<table align="center" cellspacing="0" cellpadding="0" border="0" role="presentation">
						  <tbody>
							<tr>
							  <td width="300" class="o_btn o_bg-success o_br o_heading o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #0ec06e;border-radius: 4px;">
								<a class="o_text-white" href="##siteUrl##" style="text-decoration: none;outline: none;color: #ffffff;display: block;padding: 12px 24px;mso-text-raise: 3px;">Join Us</a>
							  </td>
							</tr>
						  </tbody>
						</table>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
	<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text-xs o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p class="o_mb" style="margin-top: 0px;margin-bottom: 16px;"><strong>Username</strong></p>
						<table role="presentation" cellspacing="0" cellpadding="0" border="0">
						  <tbody>
							<tr>
							  <td width="284" class="o_bg-ultra_light o_br o_text-xs o_sans o_px-xs o_py" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ebf5fa;border-radius: 4px;padding-left: 8px;padding-right: 8px;padding-top: 16px;padding-bottom: 16px;">
								<p class="o_text-dark" style="color: #242b3d;margin-top: 0px;margin-bottom: 0px;"><strong>##UserName##</strong></p>
							  </td>
							</tr>
						  </tbody>
						</table>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- label-xs -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text-xs o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p class="o_mb" style="margin-top: 0px;margin-bottom: 16px;"><strong>Password</strong></p>
						<table role="presentation" cellspacing="0" cellpadding="0" border="0">
						  <tbody>
							<tr>
							  <td width="284" class="o_bg-ultra_light o_br o_text-xs o_sans o_px-xs o_py" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ebf5fa;border-radius: 4px;padding-left: 8px;padding-right: 8px;padding-top: 16px;padding-bottom: 16px;">
								<p class="o_text-dark" style="color: #242b3d;margin-top: 0px;margin-bottom: 0px;"><strong>##Password##</strong></p>
							  </td>
							</tr>
						  </tbody>
						</table>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- spacer -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- alert-primary -->
   
		<!-- spacer -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- content -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p style="margin-top: 0px;margin-bottom: 0px;">Thanks for choosing to be part of our company! We are all working towards a common goal and your contribution is integral. Congratulations and welcome aboard!</p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- spacer-lg -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white" style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp; </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- footer-3cols -->
		<table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center" style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
						<div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
						  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
						  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
							<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights reserved</p>
						<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944    - info@snovasys.com</p>
						<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road London - TW4 6JQ</p>
						<p style="margin-top: 0px;margin-bottom: 0px;">
							  Learn more at <a class="o_text-dark_light o_underline" href=##Registersite## style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> 
						  </p>
						  </div>
						</div>
						<!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->
						<div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
						  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
						  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
							<p style="margin-top: 0px;margin-bottom: 0px;">
							  <a class="o_text-dark_light" href="https://www.facebook.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=68BE1104-6486-4C48-92CE-51655C220EC8" width="36" height="36" alt="fb" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							  <a class="o_text-dark_light" href="https://twitter.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=724466D8-BC90-4747-A28D-18D810516738" width="36" height="36" alt="tw" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							  <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F23ACFD-6145-4431-B55A-E117BBF8AD4C" width="36" height="36" alt="ig" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							</p>
						  </div>
						</div>
					   </td>
					</tr>
				  </tbody>
				</table>
	  </body>
	</html>',@CompanyId),
	(N'RegistrationVerificationEmailTemplate',
			'<!doctype html>
	<html lang="en">
	  <head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta name="x-apple-disable-message-reformatting">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>Account Verification</title>
		<style type="text/css">
		  a { text-decoration: none; outline: none; }
		  @media (max-width: 649px) {
			.o_col-full { max-width: 100% !important; }
			.o_col-half { max-width: 50% !important; }
			.o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important; overflow: visible !important; width: auto !important; visibility: visible !important; }
			.o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }
			.o_xs-center { text-align: center !important; }
			.o_xs-left { text-align: left !important; }
			.o_xs-right { text-align: left !important; }
			table.o_xs-left { margin-left: 0 !important; margin-right: auto !important; float: none !important; }
			table.o_xs-right { margin-left: auto !important; margin-right: 0 !important; float: none !important; }
			table.o_xs-center { margin-left: auto !important; margin-right: auto !important; float: none !important; }
			h1.o_heading { font-size: 32px !important; line-height: 41px !important; }
			h2.o_heading { font-size: 26px !important; line-height: 37px !important; }
			h3.o_heading { font-size: 20px !important; line-height: 30px !important; }
			.o_xs-py-md { padding-top: 24px !important; padding-bottom: 24px !important; }
			.o_xs-pt-xs { padding-top: 8px !important; }
			.o_xs-pb-xs { padding-bottom: 8px !important; }
		  }
		  @media screen {
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 400;
			  src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
			  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 400;
			  src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
			  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 700;
			  src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
			  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
			@font-face {
			  font-family: Roboto;
			  font-style: normal;
			  font-weight: 700;
			  src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
			  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
			.o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }
			.o_heading, strong, b { font-weight: 700 !important; }
			a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }
		  }
		</style>
		<!--[if mso]>
		<style>
		  table { border-collapse: collapse; }
		  .o_col { float: left; }
		</style>
		<xml>
		  <o:OfficeDocumentSettings>
			<o:PixelsPerInch>96</o:PixelsPerInch>
		  </o:OfficeDocumentSettings>
		</xml>
		<![endif]-->
	  </head>
	  <body class="o_body o_bg-light" style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">
		<!-- preview-text -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_hide" align="center" style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">Email Summary (Hidden)</td>
			</tr>
		  </tbody>
		</table>
		<!-- header -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs o_pt-lg o_xs-pt-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;padding-top: 32px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-dark o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #242b3d;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
						<p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white" style="text-decoration: none;outline: none;color: #ffffff;"><img src=##CompanyLogo## width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- hero-icon-lines -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-ultra_light o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ebf5fa;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
						<table role="presentation" cellspacing="0" cellpadding="0" border="0">
						  <tbody>
							<tr>
							  <td class="o_bb-primary" height="40" width="32" style="border-bottom: 1px solid #126de5;">&nbsp; </td>
							  <td rowspan="2" class="o_sans o_text o_text-secondary o_px o_py" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
								<img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=71F394A4-A1C2-481E-82B5-066E1B2C995F" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
							  </td>
							  <td class="o_bb-primary" height="40" width="32" style="border-bottom: 1px solid #126de5;">&nbsp; </td>
							</tr>
							<tr>
							  <td height="40">&nbsp; </td>
							  <td height="40">&nbsp; </td>
							</tr>
							<tr>
							  <td style="font-size: 8px; line-height: 8px; height: 8px;">&nbsp; </td>
							  <td style="font-size: 8px; line-height: 8px; height: 8px;">&nbsp; </td>
							</tr>
						  </tbody>
						</table>
						<h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">Let''s make sure it''s really you</h2>
						<p style="margin-top: 0px;margin-bottom: 0px;">Thank you and congratulations for choosing Snovasys Business Suite Software.</p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- spacer -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		 <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p style="margin-top: 0px;margin-bottom: 0px;">All you have to do now is to enter the below verification code in the registration form to confirm your identity.</p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- label-xs -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text-xs o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p class="o_mb" style="margin-top: 0px;margin-bottom: 16px;"><strong>Verification Code</strong></p>
						<table role="presentation" cellspacing="0" cellpadding="0" border="0">
						  <tbody>
							<tr>
							  <td width="284" class="o_bg-ultra_light o_br o_text-xs o_sans o_px-xs o_py" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;background-color: #ebf5fa;border-radius: 4px;padding-left: 8px;padding-right: 8px;padding-top: 16px;padding-bottom: 16px;">
								<p class="o_text-dark" style="color: #242b3d;margin-top: 0px;margin-bottom: 0px;"><strong>##OTP##</strong></p>
							  </td>
							</tr>
						  </tbody>
						</table>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- button-primary -->
   
 
   
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p style="margin-top: 0px;margin-bottom: 0px;">If you have closed the window or navigated away from the registration form, you may register again because we only store user data after successful email validation.</p>
					  </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- spacer-lg -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
		  <tbody>
			<tr>
			  <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
				<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
				<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_bg-white" style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp; </td>
					</tr>
				  </tbody>
				</table>
				<!--[if mso]></td></tr></table><![endif]-->
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- footer-white -->
		 <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
				  <tbody>
					<tr>
					  <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center" style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">
						<div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">
						  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
						  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">
							<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights reserved</p>
						<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944    - info@snovasys.com</p>
						<p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road London - TW4 6JQ</p>
						<p style="margin-top: 0px;margin-bottom: 0px;">
							  Learn more at <a class="o_text-dark_light o_underline" href=##Registersite## style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> 
						  </p>
						  </div>
						</div>
						<!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->
						<div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
						  <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
						  <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
							<p style="margin-top: 0px;margin-bottom: 0px;">
							  <a class="o_text-dark_light" href="https://www.facebook.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=68BE1104-6486-4C48-92CE-51655C220EC8" width="36" height="36" alt="fb" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							  <a class="o_text-dark_light" href="https://twitter.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=724466D8-BC90-4747-A28D-18D810516738" width="36" height="36" alt="tw" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							  <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F23ACFD-6145-4431-B55A-E117BBF8AD4C" width="36" height="36" alt="ig" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>
							</p>
						  </div>
						</div>
					   </td>
					</tr>
				  </tbody>
				</table>
	  </body>
	</html>',@CompanyId),
	('ProjectMemberRemovedEmailTemplate','<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> <html xmlns="http://www.w3.org/1999/xhtml"> <head> <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> <!--[if !mso]><!--> <meta http-equiv="X-UA-Compatible" content="IE=edge" /> <!--<![endif]--> <meta name="viewport" content="width=device-width, initial-scale=1.0" /> <title></title> <style type="text/css"> * { -webkit-font-smoothing: antialiased; } body { Margin: 0; padding: 0; min-width: 100%; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased; mso-line-height-rule: exactly; } table { border-spacing: 0; color: #333333; font-family: Arial, sans-serif; } img { border: 0; } .wrapper { width: 100%; table-layout: fixed; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; } .webkit { max-width: 600px; } .outer { Margin: 0 auto; width: 100%; max-width: 600px; } .full-width-image img { width: 100%; max-width: 600px; height: auto; } .inner { padding: 10px; } p { Margin: 0; padding-bottom: 10px; } .h1 { font-size: 21px; font-weight: bold; Margin-top: 15px; Margin-bottom: 5px; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased; } .h2 { font-size: 18px; font-weight: bold; Margin-top: 10px; Margin-bottom: 5px; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased; } .one-column .contents { text-align: left; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased; } .one-column p { font-size: 14px; Margin-bottom: 10px; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased; } .two-column { text-align: center; font-size: 0; } .two-column .column { width: 100%; max-width: 300px; display: inline-block; vertical-align: top; } .contents { width: 100%; } .two-column .contents { font-size: 14px; text-align: left; } .two-column img { width: 100%; max-width: 280px; height: auto; } .two-column .text { padding-top: 10px; } .three-column { text-align: center; font-size: 0; padding-top: 10px; padding-bottom: 10px; } .three-column .column { width: 100%; max-width: 200px; display: inline-block; vertical-align: top; } .three-column .contents { font-size: 14px; text-align: center; } .three-column img { width: 100%; max-width: 180px; height: auto; } .three-column .text { padding-top: 10px; } .img-align-vertical img { display: inline-block; vertical-align: middle; } .download-button { background-color: #009999; border: none; color: white; padding: 15px 32px; text-align: center; text-decoration: none; display: inline-block; font-size: 16px; margin: 4px 2px; cursor: pointer; } @@media only screen and (max-device-width: 480px) { table[class=hide], img[class=hide], td[class=hide] { display: none !important; } .contents1 { width: 100%; } .contents1 { width: 100%; } } </style> </head> <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;"> <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;"> <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;"> <tr> <td width="100%"> <div class="webkit" style="max-width:600px;Margin:0 auto;"> <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;"> <tr> <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;"> <table border="0" width="100%" cellpadding="0" cellspacing="0"> <tr> <td> <table style="width:100%;" cellpadding="0" cellspacing="0" border="0"> <tbody> <tr> <td align="center"> <center> <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;"> <tbody> <tr> <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF"> <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0"> <tr> <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;"> <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;"> <table class="contents" style="border-spacing:0; width:100%"> <tr> <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left"> <a href="#" target="_blank"><img src=##CompanyLogo## alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a> </td> </tr> </table> </div> <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;"> <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0"> <tr> <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;"> <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0"> <tr> <td align="left" valign="top">&nbsp;</td> </tr> <tr></tr> </table> </td> </tr> </table> </div> </td> </tr> <tr> <td>&nbsp;</td> </tr> </table> </td> </tr> </tbody> </table> </center> </td> </tr> </tbody> </table> </td> </tr> </table> <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF"> <tr> <td align="left" style="padding:50px 50px 50px 50px"> <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"> <h2>##OperationPerformedUser## removed access to project - ##ProjectName##</h2> </p> <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px "> <br /> Best Regards, <br /> ##footerName## </p> </td> </tr> </table> </td> </tr> </table> </div> </td> </tr> </table> </center> </body></html>',@CompanyId),
(N'InvoicePDFTemplate',
		'<!DOCTYPE html>
<html>

<style>
    .div {
        box-sizing: border-box;
    }

    .p-1 {
        padding: 1rem !important;
    }

    h6 {
        font-size: 1rem;
        margin-bottom: .5rem;
        font-weight: 400;
        line-height: 1.1;
        color: inherit;
        margin-top: 0;
    }

    .fxLayout-row {
        flex-flow: row wrap;
        box-sizing: border-box;
        display: flex;
    }

    .fxFlex48 {
        flex: 1 1 100%;
        box-sizing: border-box;
        max-width: 48%;
    }

    .fxFlex {
        flex: 1 1 0%;
        box-sizing: border-box;
    }

    .fxFlex49-column {
        flex: 1 1 100%;
        box-sizing: border-box;
        flex-direction: column;
        display: flex;
        max-width: 49%;
    }

    .fxFlex50-row-start {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: center flex-start;
        align-items: center;
        flex-direction: row;
        display: flex;
        max-width: 50%;
    }

    .fxFlex50-column-start {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: center flex-start;
        align-items: center;
        flex-direction: column;
        display: block;
        max-width: 50%;
    }

    .fxFlex50-column-end {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: flex-start flex-end;
        align-items: center;
        flex-direction: column;
        display: block;
        max-width: 50%;
    }

    .fxFlex100 {
        flex: 1 1 100%;
        box-sizing: border-box;
        max-width: 100%;
    }

    .fxFlex100-end {
        flex: 1 1 100%;
        box-sizing: border-box;
        place-content: flex-start flex-end;
        align-items: flex-start;
        flex-direction: row;
        display: flex;
        max-width: 100%;
    }

    .fxLayout-end {
        place-content: center flex-end;
        align-items: center;
        flex-direction: row;
        box-sizing: border-box;
        display: flex;
    }

    .word-break {
        word-break: break-word !important;
    }

    .d-block {
        display: bloack !important;
    }

    .mb-1 {
        margin-bottom: 1rem !important;
    }

    .mt-02 {
        margin-top: .3rem !important;
    }

    .mt-1 {
        margin-top: 1rem !important;
    }

    .mt-1-05 {
        margin-top: 1.5rem;
    }

    .ml-1 {
        margin-left: 1rem !important;
    }

    .mt-05 {
        margin-top: .5rem !important;
    }
    
    .mr-05 {
        margin-right: .5rem !important;
    }

    .invoice-amount-price {
        font-size: 23px;
        font-weight: 700;
        position: relative;
        top: 1px;
    }

    .overflow-visible {
        overflow: visible;
    }

    .table-responsive {
        display: block;
        width: 100%;
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
    }

    .mb-0 {
        margin-bottom: 0 !important;
    }

    .table {
        width: 100%;
        margin-bottom: 1rem;
        color: #212529;
    }

    table {
        border-collapse: collapse;
    }

    .invoice-container td:first-child,
    .invoice-container th:first-child {
        text-align: inherit;
        padding-left: 0;
        width: 40%;
    }

    .table thead th {
        vertical-align: bottom;
        border-bottom: 2px solid #dee2e6;
    }

    .invoice-container td,
    .invoice-container th {
        padding-right: 0;
        text-align: right;
        width: 13%;
    }

    .table td,
    .table th {
        padding: .75rem;
        vertical-align: top;
        border-top: 1px solid #dee2e6;
    }

	td    { page-break-before: always; }
	th    { page-break-before: always; }

	@page {
		margin-top: 10px;
		margin-bottom: 10px
	}
</style>

<body>
    <div class="p-1 invoice-preview-height">
		##invoicePDFJson##
	</div>
</body>

</html>
		',@CompanyId),
		 ('BurndownTemplate',
                  '<!DOCTYPE html>
        <head>
          <meta charset="utf-8">
          <script src="https://d3js.org/d3.v4.min.js"></script>
          <style>
            body { margin:0;position:fixed;top:0;right:0;bottom:0;left:0; }
            
            .line {
              fill: none;
              stroke: steelblue;
              stroke-width: 1.5px;
        }
        .h1 {
          font: 200 1.2em "Segoe UI Light", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif;
          font-weight: bold;
          padding: 20px;
          margin: 0;
          border-bottom: 10px solid #ccc;
          strong {
            font-family: "Segoe UI Black";
            font-weight: bold;
          }
        }
          </style>
        </head>
        
        <body>
          <script>
            
            var svg = d3.select("body").append("svg")
              .attr("width", 850)
              .attr("height", 400)
        
            var margin = {left:50, right:30, top: 60, bottom: 60}
            var width = svg.attr("width") - margin.left - margin.right;
            var height = svg.attr("height") - margin.bottom - margin.top;
            
               var data = ##burndownChartJson## 
            var x = d3.scaleTime()
            	.rangeRound([0, width]);
            var x_axis = d3.axisBottom(x);
            
            var y = d3.scaleLinear()
            	.rangeRound([height, 0]);
            var y_axis = d3.axisBottom(y);
            var xFormat = "%d-%b-%Y";;
            var parseTime = d3.timeParse("%d/%m/%Y");
            
            x.domain(d3.extent(data, function(d) { return parseTime(d.date); }));
          	y.domain([0, ##yMax##]);
        
            var a = function(d) {return d.expected};
            
            var multiline = function(category) {
              var line = d3.line()
                          .x(function(d) { return x(parseTime(d.date)); })
                          .y(function(d) { return y(d[category]); });
              return line;
            }
            
           
        
            var categories = [''expected'', ''actual'', ''c'', ''d''];
            //var color = d3.scale.category10();  // escala com 10 cores (category10)
            var color = d3.scaleOrdinal(d3.schemeCategory10);
            
            var g = svg.append("g")
                .attr("transform",
                  "translate(" + margin.left + "," + margin.top + ")");
            
            for (i in categories) {
              var lineFunction = multiline(categories[i]);
              g.append("path")
                .datum(data) 
                .attr("class", "line")
                .style("stroke", color(i))
                .attr("d", lineFunction);
            }
            
              // Add the X Axis
          		g.append("g")
              .attr("transform", "translate(0," + height + ")")
              .call(d3.axisBottom(x).ticks(d3.timeDay.every(1)).tickFormat(d3.timeFormat(xFormat)))
            .selectAll("text")
            .attr("transform", "translate(-20,10)rotate(-45)");
            
        	
              // Add the Y Axis
          		g.append("g")
              .call(d3.axisLeft(y));
        	  
        	  svg.append("text")
        		.attr("class", "h1")
        		.attr("text-anchor", "end")
        		.attr("y", 25)
        		.attr("x", 500)
        		.attr("dy", "0.75em")
        		.text("Work burn down");
        
          </script>
        </body>',@CompanyId)
        ,('AssetsTemplate',
        '<!DOCTYPE html>
        <html>
        <head>
        <link href="https://fonts.googleapis.com/css?family=Roboto&display=swap" rel="stylesheet">
        <style>
        #para{font-family: "Roboto", sans-serif;font-weight:bold;font-size:15px;padding-left:0px}
        #para1{float: right;margin-top:80px;margin-right:80px;font-size: 14px;font-family: "Roboto", sans-serif;}
        .a{border: 1px solid #dddddd;text-align: left;padding: 6px ;width:80%;font-family:"Roboto", sans-serif;border-collapse: collapse}
        .b{border: 1px solid #dddddd;text-align: left;padding: 6px ;width:8%;font-family:"Roboto", sans-serif;border-collapse: collapse;font-size:15px;font-weight: 400;word-break:break-word}
        img{position:absolute;left:80px;top:50px;height:50px;width:200px}
        table { page-break-inside:auto }
        tr    { page-break-inside:avoid; page-break-after:auto }
        thead { display:table-header-group }
        tfoot { display:table-footer-group }
        @page :left {margin-top: 1cm;}
        </style>
        </head>
        <body>
        ##assetsListJson##
        <p id="para1">Signature</p>
        </body></html>',@CompanyId)
		,('SplitBarChartTemplate',
        '<!DOCTYPE html>
        <meta charset="utf-8"> 
        <head>
        
        </head>
        
        <script src="https://d3js.org/d3.v4.js"></script>
        
        
        <div id="chart"></div>
        
        <div id="tooltip"></div>
        
        <script src="https://d3js.org/d3-scale-chromatic.v1.min.js"></script>
        
        
        <script>
        var maxProd = 1;
        
        var myData = [];
        var dataFromDB = ##splitBarChartJson##;
        var subGroups = [];
        
        convertDataToD3Format(dataFromDB);
        createChart(dataFromDB);
        
        function convertDataToD3Format(data) {
                var dataSet = data;
        		var maxProdValue = [];
                if (dataSet && dataSet.length > 0) {
                    dataSet.forEach(x => {
                        var obj = {};
                        var names = x.ConfigurationName.split(",");
                        var values = x.ConfigurationTime.split(",");
                        obj["dateName"] = x.DateName;
                        obj["originalSpentTime"] = x.OriginalSpentTime;
        				obj["bugsCountText"] = x.BugsCountText;
                        names.forEach((y, i) => {
                            obj[y] = values[i];
        					maxProdValue.push(parseFloat(values[i]));
                        });
        				maxProdValue.push(x.OriginalSpentTime);
                        myData.push(obj);
                    });
        			subGroups = dataSet[0].ConfigurationName.split(",");
                    maxProd = Math.max(...maxProdValue);
        			if (maxProd == 0)
        				maxProd = 1;
                }
        		else
        			maxProd = 1;
            }
        
        function createChart(data) {
        		var color = d3.scaleOrdinal()
        						.domain(subGroups)
        						.range(["blue","#d2691e","orange","#6554c0","red","#ff5630","#00b8d9","#04fe02","#757575"]);
        	
        		var stackedData = d3.stack()
        							.keys(subGroups)	
        							(myData)						
                d3.select("#chart").select("svg").remove();
                var margin = { top: 30, right: 30, bottom: 70, left: 60 },
                    width = 360 - margin.left - margin.right,
                    height = 300 - margin.top - margin.bottom;
        
                var tooltip = d3.select("#toolTip").attr("class", "toolTip");
        
                var svg = d3.select("#chart")
                    .classed("svg-container", true)
                    .append("svg")
                    .attr("preserveAspectRatio", "xMinYMin meet")
                    .attr("viewBox", "0 0 900 400")
                    .classed("svg-content-responsive", true)
                    .append("g")
                    .attr("transform",
                        "translate(280,30)");
        
                var x = d3.scaleBand()
                    .range([0, width])
                    .domain(myData.map(function (d) { return d.dateName; }))
                    .padding(0.4);
        
                svg.append("g")
                    .attr("transform", "translate(0,200)")
                    .call(d3.axisBottom(x))
                    .selectAll("text")
                    .attr("transform", "translate(-10,0)rotate(-45)")
                    .style("text-anchor", "end");
        
                svg.append("text")
                    .attr("x", 135)
                    .attr("y", 270)
                    .style("text-anchor", "middle")
                    .text("Time period");
        		
        		// Right side text
        		svg.append("text")
                    .attr("x", 365)
                    .attr("y", 20)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Original spent time")
        			.attr("fill","green");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 35)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Test case created/updated")
        			.attr("fill","blue");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 50)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Scenario created/updated")
        			.attr("fill","#d2691e");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 65)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Run created/updated")
        			.attr("fill","orange");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 80)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Test case status updated")
        			.attr("fill","#6554c0");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 95)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Bugs created/updated")
        			.attr("fill","red");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 110)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Version created/updated")
        			.attr("fill","#ff5630");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 125)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Test report created/updated")
        			.attr("fill","#00b8d9");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 140)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Test case viewed")
        			.attr("fill","#04fe02");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 155)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Scenario section created/updated")
        			.attr("fill","#757575");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 170)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Bugs created today")
        			.attr("fill","red");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 185)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text(data[0].BugsCountText)
        			.attr("fill","red");
        
                var y = d3.scaleLinear()
                    .domain([0, maxProd])
                    .range([height, 0]);
        
                svg.append("g")
                    .call(d3.axisLeft(y));
        
                svg.append("text")
                    .attr("transform", "rotate(-90)")
                    .attr("y", -50)
                    .attr("x", -105)
                    .attr("dy", "1em")
                    .style("text-anchor", "middle")
                    .text("Effective spent time (hr)");
        		
        		svg.selectAll("mybar1")
                    .data(myData)
                    .enter()
                    .append("rect")
                    .attr("x", function (d) { 
        				return x(d["dateName"]); 
        				})
                    .attr("y", function (d) { 
        				return y(0); 
        				})
                    .attr("width", 10)
                    .attr("height", function (d) { 
        				return height - y(0); 
        				})
                    .attr("fill", "green")
        
        		// Tooltip
                svg.selectAll("rect")
                    .data(myData)
                    .on("mousemove", function (d) {
                        tooltip
                            .style("left", d3.event.pageX - 50 + "px")
                            .style("top", d3.event.pageY - 70 + "px")
                            .style("display", "inline-block")
                            .html(("Day: " + d["dateName"]) + "<br>" + "Effective spent time: " + (d["originalSpentTime"]));
                    })
                    .on("mouseout", function (d) { tooltip.style("display", "none"); });
        
                svg.selectAll("rect")
                    .attr("y", function (d) { return y(d["originalSpentTime"]); })
                    .attr("height", function (d) { return height - y(d["originalSpentTime"]); })
        			
        
        		// Show the bars			
        			svg.append("g")
        				.selectAll("g")
        				.data(stackedData)
        				.enter().append("g")
        				.attr("fill", function(d) { 
        					return color(d.key); 
        				})
        				.selectAll("rect")
        				.data(function(d) { 
        					return d; 
        				})
        				.enter().append("rect")
        				.attr("x", function(d) { 
        					return x(d.data.dateName); 
        				})
        				.attr("y", function(d) { 
        					return y(d[1]); 
        				})
        				.attr("height", function(d) { 
        					return y(d[0]) - y(d[1]); 
        				})
        				.attr("width",10)
        				.attr("transform",
                        "translate(11,0)")
            }
        </script>',@CompanyId),
        ('CompanyRegistrationDemoDataTemplate'
        ,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
            <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
                    <tr>
                        <td width="100%">
                            <div class="webkit" style="max-width:600px;Margin:0 auto;">
                                <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                                    <tr>
                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <center>
                                                                            <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                                <tr>
                                                                                                    <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                        <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                                                            <table class="contents" style="border-spacing:0; width:100%">
                                                                                                                <tr>
                                                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                                                    @*<a href="#" target="_blank"><img src=##CompanyLogo## alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>*@
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                            <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                        <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </center>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                                <tr>
                                                    <td align="left" style="padding:50px 50px 50px 50px">
                                                        <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h2>Dear ##ToName##,</h2></p>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            Thank you for choosing Snovasys Business Suite to grow your business.Hope you have a great success in the coming future.We are creating your site, once it is finished, we will let you know.Please go through the below link and find the terms and conditions of Snovasys Business Suite<br />
                                                            <br />
                                                            <br />
                                                        </p>
                                                        <table border="0" align="left" cellpadding="0" cellspacing="0" style="Margin:0 auto;">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <table border="0" cellpadding="0" cellspacing="0" style="Margin:0 auto;">
                                                                            <tr>
                                                                                <td width="250" height="60" align="center" bgcolor="#009999" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;"><a href="https://snovasys.com/Documents/SnovasysTerms.pdf" style="width:250px; display:block; text-decoration:none; border:0; text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff">Terms and Conditions</a></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />
                                                            <br />
                                                            <br />
                                                            <br />
                                                            <br />
                                                            Best Regards, <br />
                                                            ##footerName##
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </center>
        </body>
        </html>',@CompanyId),
        ('TestRailReportTemplate'
        ,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                .download-button {
                    background-color: #4CAF50;
                    border: none;
                    color: white;
                    padding: 15px 32px;
                    text-align: center;
                    text-decoration: none;
                    display: inline-block;
                    font-size: 16px;
                    margin: 4px 2px;
                    cursor: pointer;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
            <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
                    <tr>
                        <td width="100%">
                            <div class="webkit" style="max-width:600px;Margin:0 auto;">
                                <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                                    <tr>
                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <center>
                                                                            <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                                <tr>
                                                                                                    <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                        <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                                                            <table class="contents" style="border-spacing:0; width:100%">
                                                                                                                <tr>
                                                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left"><a href="#" target="_blank"><img src=##CompanyLogo## alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                            <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                        <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </center>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                                <tr>
                                                    <td align="left" style="padding:50px 50px 50px 50px">
                                                        <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h2>Dear User ,</h2></p>
                                                        <p style="color:#000000; font-size:14px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            The following Testrepo report was sent to you:<br /><br />
                                                            <b>##ReportName##</b><br /><br />
                                                            If the email contains a PDF, after downloading it you can open it in your preferred PDF viewer.<br />
                                                        </p>
                                                        <a class="download-button" href="##PdfUrl##" target="_blank">Click here to download report</a>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />
                                                            Best Regards, <br />
                                                            ##footerName##
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </center>
        </body>
        </html>',@CompanyId),
        ('LeaveApplicationTemplate'
        ,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                .download-button {
                    background-color: #009999;
                    border: none;
                    color: white;
                    padding: 15px 32px;
                    text-align: center;
                    text-decoration: none;
                    display: inline-block;
                    font-size: 16px;
                    margin: 4px 2px;
                    cursor: pointer;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
            <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
                    <tr>
                        <td width="100%">
                            <div class="webkit" style="max-width:600px;Margin:0 auto;">
                                <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                                    <tr>
                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <center>
                                                                            <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                                <tr>
                                                                                                    <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                        <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                                                            <table class="contents" style="border-spacing:0; width:100%">
                                                                                                                <tr>
                                                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left"><a href="#" target="_blank"><img src=##CompanyLogo## alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                            <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                        <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </center>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                                <tr>
                                                    <td align="left" style="padding:50px 50px 50px 50px">
                                                        <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h2>Dear sir/madam ,</h2></p>
                                                        <p style="color:#000000; font-size:14px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />##ToName## has applied leave from ##leaveFromDate## to ##leaveDateTo## for ##NoofDays## day(s)
                                                        </p>
                                                       <div style="width: 100%;text-align: center;">
        													<button class="download-button" target="_blank" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;            background-color: #009999;border: none;color: white;padding: 15px 32px;text-align: center;text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px;cursor: pointer; ">
        														<a style="text-decoration:none;text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff"" href="##siteAddress##">Click here to Accept/Decline</a> 
        													</button>      
        												</div>   
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />
                                                            Best Regards, <br />
                                                            BTrak Team
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </center>
			</body>
        </html>',@CompanyId),
		('AssetNotificationTemplate'
        ,'<!DOCTYPE html
  PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!--[if !mso]><!-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!--<![endif]-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title></title>
    <style type="text/css">
        * {
            -webkit-font-smoothing: antialiased;
        }
        
        body {
            Margin: 0;
            padding: 0;
            min-width: 100%;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
            mso-line-height-rule: exactly;
        }
        
        table {
            border-spacing: 0;
            color: #333333;
            font-family: Arial, sans-serif;
        }
        
        img {
            border: 0;
        }
        
        .wrapper {
            width: 100%;
            table-layout: fixed;
            -webkit-text-size-adjust: 100%;
            -ms-text-size-adjust: 100%;
        }
        
        .webkit {
            max-width: 600px;
        }
        
        .outer {
            Margin: 0 auto;
            width: 100%;
            max-width: 600px;
        }
        
        .full-width-image img {
            width: 100%;
            max-width: 600px;
            height: auto;
        }
        
        .inner {
            padding: 10px;
        }
        
        p {
            Margin: 0;
            padding-bottom: 10px;
        }
        
        .h1 {
            font-size: 21px;
            font-weight: bold;
            Margin-top: 15px;
            Margin-bottom: 5px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }
        
        .h2 {
            font-size: 18px;
            font-weight: bold;
            Margin-top: 10px;
            Margin-bottom: 5px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }
        
        .one-column .contents {
            text-align: left;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }
        
        .one-column p {
            font-size: 14px;
            Margin-bottom: 10px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }
        
        .two-column {
            text-align: center;
            font-size: 0;
        }
        
        .two-column .column {
            width: 100%;
            max-width: 300px;
            display: inline-block;
            vertical-align: top;
        }
        
        .contents {
            width: 100%;
        }
        
        .two-column .contents {
            font-size: 14px;
            text-align: left;
        }
        
        .two-column img {
            width: 100%;
            max-width: 280px;
            height: auto;
        }
        
        .two-column .text {
            padding-top: 10px;
        }
        
        .three-column {
            text-align: center;
            font-size: 0;
            padding-top: 10px;
            padding-bottom: 10px;
        }
        
        .three-column .column {
            width: 100%;
            max-width: 200px;
            display: inline-block;
            vertical-align: top;
        }
        
        .three-column .contents {
            font-size: 14px;
            text-align: center;
        }
        
        .three-column img {
            width: 100%;
            max-width: 180px;
            height: auto;
        }
        
        .three-column .text {
            padding-top: 10px;
        }
        
        .img-align-vertical img {
            display: inline-block;
            vertical-align: middle;
        }
        
        .download-button {
            background-color: #009999;
            border: none;
            color: white;
            padding: 15px 32px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
        }
        
        @@media only screen and (max-device-width: 480px) {
            table[class=hide], img[class=hide], td[class=hide] {
                display: none !important;
            }
            .contents1 {
                width: 100%;
            }
            .contents1 {
                width: 100%;
            }
        }
    </style>
</head>

<body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
    <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
        <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
                <td width="100%">
                    <div class="webkit" style="max-width:600px;Margin:0 auto;">
                        <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                            <tr>
                                <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                    <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td>
                                                <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                    <tbody>
                                                        <tr>
                                                            <td align="center">
                                                                <center>
                                                                    <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                        <tr>
                                                                                            <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                                                    <table class="contents" style="border-spacing:0; width:100%">
                                                                                                        <tr>
                                                                                                            <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                                                <a href="#" target="_blank">
                                                                                                                    <img src=##CompanyLogo## alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" />
                                                                                                                </a>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </div>
                                                                                                <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                    <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                        <tr>
                                                                                                            <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                    <tr>
                                                                                                                        <td align="left" valign="top">&nbsp;</td>
                                                                                                                    </tr>
                                                                                                                    <tr></tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </center>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                        <tr>
                                            <td align="left" style="padding:50px 50px 50px 50px">
                                                <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                                    <h2>Dear ##userName## ,</h2>
                                                </p>
                                                <p style="color:#000000; font-size:14px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    <br />The following asset(s) ##assets## with codes ##assetNumbers## has been assigned to you.</p>
                                                <div style="width: 100%;text-align: center;">
                                                    <button class="download-button" target="_blank" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;            background-color: #009999;border: none;color: white;padding: 15px 32px;text-align: center;text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px;cursor: pointer; ">
                                                        <a style="text-decoration:none;text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff" " href="##siteAddress##">Click here to take action</a>                        </button>                            </div>                                                             <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                       
<br/>                                                           
Best Regards, <br/>                                             
BTrak Team                                  
</p>                                
</td>                               
</tr>                          
</table>                        
</td>                     
</tr>                    
</table>                
</div>             
</td>             
</tr>              
</table>          
</center>  
</body>
</html>',@CompanyId)
		,('EmployeeRosterTemplate'
,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head> <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> <meta http-equiv="X-UA-Compatible" content="IE=edge"/> <meta name="viewport" content="width=device-width, initial-scale=1.0"/> <title></title> <style type="text/css"> *{-webkit-font-smoothing: antialiased;}body{Margin: 0; padding: 0; min-width: 100%; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased; mso-line-height-rule: exactly;}table{border-spacing: 0; color: #333333; font-family: Arial, sans-serif;}img{border: 0;}.wrapper{width: 100%; table-layout: fixed; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;}.webkit{max-width: 600px;}.outer{Margin: 0 auto; width: 100%; max-width: 600px;}.full-width-image img{width: 100%; max-width: 600px; height: auto;}.inner{padding: 10px;}p{Margin: 0; padding-bottom: 10px;}.h1{font-size: 21px; font-weight: bold; Margin-top: 15px; Margin-bottom: 5px; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased;}.h2{font-size: 18px; font-weight: bold; Margin-top: 10px; Margin-bottom: 5px; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased;}.one-column .contents{text-align: left; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased;}.one-column p{font-size: 14px; Margin-bottom: 10px; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased;}.two-column{text-align: center; font-size: 0;}.two-column .column{width: 100%; max-width: 300px; display: inline-block; vertical-align: top;}.contents{width: 100%;}.two-column .contents{font-size: 14px; text-align: left;}.two-column img{width: 100%; max-width: 280px; height: auto;}.two-column .text{padding-top: 10px;}.three-column{text-align: center; font-size: 0; padding-top: 10px; padding-bottom: 10px;}.three-column .column{width: 100%; max-width: 200px; display: inline-block; vertical-align: top;}.three-column .contents{font-size: 14px; text-align: center;}.three-column img{width: 100%; max-width: 180px; height: auto;}.three-column .text{padding-top: 10px;}.img-align-vertical img{display: inline-block; vertical-align: middle;}.download-button{background-color: #4CAF50; border: none; color: white; padding: 15px 32px; text-align: center; text-decoration: none; display: inline-block; font-size: 16px; margin: 4px 2px; cursor: pointer;}@@media only screen and (max-device-width: 480px){table[class=hide], img[class=hide], td[class=hide]{display: none !important;}.contents1{width: 100%;}.contents1{width: 100%;}}.tabletd{width: 25%; vertical-align: top; padding: 2px 5px 2px 5px;}.tabletd p{margin: 5px 0}</style></head><body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;"> <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;"> <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;"> <tr> <td width="100%"> <div class="webkit" style="max-width:600px;Margin:0 auto;"> <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;"> <tr> <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;"> <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF"> <tr> <td align="left" style="padding:50px 50px 50px 50px"> <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"> <h2>Dear User ,</h2> </p><p style="color:#000000; font-size:14px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px "> Please check the below roster created by <b>##EmployeeName##</b> and have to follow the same please let us know in person, if you have any changes or queries<br/><br/> <table border="1" cellspacing="0" cellpadding="0" style="border-collapse:separate"> <tr> <th>Employee Name</th> <th>Scheduled Day</th> <th>Scheduled Time</th> <th>Department</th> </tr>##EmployeeRoster## </table> <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px "> <br/> Best Regards, <br/> ##footerName## </p></td></tr></table> </td></tr></table> </div></td></tr></table> </center></body></html>'
,@CompanyId),
		
		(N'InvoiceMailTemplate',
		'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body
    style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
    <center class="wrapper"
        style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
        <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;"
            bgcolor="#f3f2f0;">
            <tr>
                <td width="100%">
                    <div class="webkit" style="max-width:600px;Margin:0 auto;">
                        <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0"
                            style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                            <tr>
                                <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                    <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%"
                                        style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5"
                                        bgcolor="#FFFFFF">
                                        <tr>
                                            <td align="left" style="padding:50px 50px 50px 50px">
                                                <p
                                                    style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                                    <h2>Dear ##ToName##,</h2>
                                                </p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Thank you for choosing Snovasys Business Suite to grow your
                                                    business.Hope you have a great success in the coming future.<a
                                                        target="_blank" href="##PdfUrl##" style="color: #099">Click
                                                        here</a> to download the invoice.<br />
                                                    <br />
                                                </p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Best Regards, <br />
                                                    ##footerName##
                                                </p>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </center>
</body>
</html>',@CompanyId),
        (N'ScenarioExportMailTemplate',
        '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body
    style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
    <center class="wrapper"
        style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
        <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;"
            bgcolor="#f3f2f0;">
            <tr>
                <td width="100%">
                    <div class="webkit" style="max-width:600px;Margin:0 auto;">
                        <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0"
                            style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                            <tr>
                                <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                    <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%"
                                        style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5"
                                        bgcolor="#FFFFFF">
                                        <tr>
                                            <td align="left" style="padding:50px 50px 50px 50px">
                                                <p
                                                    style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                                    <h2>Dear ##ToName##,</h2>
                                                </p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Thank you for choosing Snovasys Business Suite to grow your
                                                    business.Hope you have a great success in the coming future. <a
                                                        target="_blank" href="##PdfUrl##" style="color: #099">Click
                                                        here</a> to download the exported file.<br />
                                                    <br />
                                                </p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Best Regards, <br />
                                                    ##footerName##
                                                </p>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </center>
</body>
</html>',@CompanyId),
--contact templates
(N'RemoteContactMailTemplate',
	'	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!--[if !mso]><!-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!--<![endif]-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title></title>
    <style type="text/css">
        * {
            -webkit-font-smoothing: antialiased;
        }

        body {
            Margin: 0;
            padding: 0;
            min-width: 100%;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
            mso-line-height-rule: exactly;
        }

        table {
            border-spacing: 0;
            color: #333333;
            font-family: Arial, sans-serif;
        }

        img {
            border: 0;
        }

        .wrapper {
            width: 100%;
            table-layout: fixed;
            -webkit-text-size-adjust: 100%;
            -ms-text-size-adjust: 100%;
        }

        .webkit {
            max-width: 600px;
        }

        .outer {
            Margin: 0 auto;
            width: 100%;
            max-width: 600px;
        }

        .full-width-image img {
            width: 100%;
            max-width: 600px;
            height: auto;
        }

        .inner {
            padding: 10px;
        }

        p {
            Margin: 0;
            padding-bottom: 10px;
        }

        .h1 {
            font-size: 21px;
            font-weight: bold;
            Margin-top: 15px;
            Margin-bottom: 5px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        .h2 {
            font-size: 18px;
            font-weight: bold;
            Margin-top: 10px;
            Margin-bottom: 5px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        .one-column .contents {
            text-align: left;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        .one-column p {
            font-size: 14px;
            Margin-bottom: 10px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        .two-column {
            text-align: center;
            font-size: 0;
        }

            .two-column .column {
                width: 100%;
                max-width: 300px;
                display: inline-block;
                vertical-align: top;
            }

        .contents {
            width: 100%;
        }

        .two-column .contents {
            font-size: 14px;
            text-align: left;
        }

        .two-column img {
            width: 100%;
            max-width: 280px;
            height: auto;
        }

        .two-column .text {
            padding-top: 10px;
        }

        .three-column {
            text-align: center;
            font-size: 0;
            padding-top: 10px;
            padding-bottom: 10px;
        }

            .three-column .column {
                width: 100%;
                max-width: 200px;
                display: inline-block;
                vertical-align: top;
            }

            .three-column .contents {
                font-size: 14px;
                text-align: center;
            }

            .three-column img {
                width: 100%;
                max-width: 180px;
                height: auto;
            }

            .three-column .text {
                padding-top: 10px;
            }

        .img-align-vertical img {
            display: inline-block;
            vertical-align: middle;
        }

        @@media only screen and (max-device-width: 480px) {
            table[class=hide], img[class=hide], td[class=hide] {
                display: none !important;
            }

            .contents1 {
                width: 100%;
            }

            .contents1 {
                width: 100%;
            }
        }
    </style>
</head>
<body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
    <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
        <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
                <td width="100%">
                    <div class="webkit" style="max-width:600px;Margin:0 auto;">
                        <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                            <tr>
                                <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                    <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td>
                                                <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                    <tbody>
                                                        <tr>
                                                            <td align="center">
                                                                <center>
                                                                    <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                        <tr>
                                                                                            <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                                                    <table class="contents" style="border-spacing:0; width:100%">
                                                                                                        <tr>
                                                                                                            <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                                                @*<a href="#" target="_blank"><img src=##CompanyLogo## alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>*@
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </div>
                                                                                                <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                    <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                        <tr>
                                                                                                            <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                    <tr>
                                                                                                                        <td align="left" valign="top">&nbsp;</td>
                                                                                                                    </tr>
                                                                                                                    <tr></tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </center>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                        <tr>
                                            <td align="left" style="padding:50px 50px 50px 50px">
                                                <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Hi there, I’m really excited to get started with your product. I just have a few questions before I get started.
                                                </p>
												<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                   ##description##
                                                </p>
											<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    User Name - ##userName##
                                                </p>
													<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Phone Number - ##phone##
                                                </p>
                                                <p style="color:#262626; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                   Thanks!
												   
                                                 </p>
												<p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h3>Customer Details:</h3></p>
												 <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Name - ##userName##
                                                </p>
												<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Email - ##email##
                                                </p>
												<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Phone number - ##phone##
                                                </p>
												<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Company Name - ##company##
                                                </p>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </center>
</body>
</html>',@CompanyId)

        )
        AS Source ([TemplateName], [HtmlTemplate],CompanyId) 
        ON Target.[TemplateName] = Source.[TemplateName]  
        AND Target.CompanyId = Source.CompanyId  
        WHEN MATCHED THEN 
        UPDATE SET [HtmlTemplate] = Source.[HtmlTemplate];

MERGE INTO [dbo].[HtmlTemplates] AS Target 
USING ( VALUES 

('SprintApprovedEmailTemplate',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <!--[if !mso]><!-->
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <!--<![endif]-->
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title></title>
      <style type="text/css">
         * {
         -webkit-font-smoothing: antialiased;
         }
         body {
         Margin: 0;
         padding: 0;
         min-width: 100%;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         mso-line-height-rule: exactly;
         }
         table {
         border-spacing: 0;
         color: #333333;
         font-family: Arial, sans-serif;
         }
         img {
         border: 0;
         }
         .wrapper {
         width: 100%;
         table-layout: fixed;
         -webkit-text-size-adjust: 100%;
         -ms-text-size-adjust: 100%;
         }
         .webkit {
         max-width: 600px;
         }
         .outer {
         Margin: 0 auto;
         width: 100%;
         max-width: 600px;
         }
         .full-width-image img {
         width: 100%;
         max-width: 600px;
         height: auto;
         }
         .inner {
         padding: 10px;
         }
         p {
         Margin: 0;
         padding-bottom: 10px;
         }
         .h1 {
         font-size: 21px;
         font-weight: bold;
         Margin-top: 15px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .h2 {
         font-size: 18px;
         font-weight: bold;
         Margin-top: 10px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column .contents {
         text-align: left;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column p {
         font-size: 14px;
         Margin-bottom: 10px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .two-column {
         text-align: center;
         font-size: 0;
         }
         .two-column .column {
         width: 100%;
         max-width: 300px;
         display: inline-block;
         vertical-align: top;
         }
         .contents {
         width: 100%;
         }
         .two-column .contents {
         font-size: 14px;
         text-align: left;
         }
         .two-column img {
         width: 100%;
         max-width: 280px;
         height: auto;
         }
         .two-column .text {
         padding-top: 10px;
         }
         .three-column {
         text-align: center;
         font-size: 0;
         padding-top: 10px;
         padding-bottom: 10px;
         }
         .three-column .column {
         width: 100%;
         max-width: 200px;
         display: inline-block;
         vertical-align: top;
         }
         .three-column .contents {
         font-size: 14px;
         text-align: center;
         }
         .three-column img {
         width: 100%;
         max-width: 180px;
         height: auto;
         }
         .three-column .text {
         padding-top: 10px;
         }
         .img-align-vertical img {
         display: inline-block;
         vertical-align: middle;
         }
         .download-button {
         background-color: #009999;
         border: none;
         color: white;
         padding: 15px 32px;
         text-align: center;
         text-decoration: none;
         display: inline-block;
         font-size: 16px;
         margin: 4px 2px;
         cursor: pointer;
         }
         @@media only screen and (max-device-width: 480px) {
         table[class=hide], img[class=hide], td[class=hide] {
         display: none !important;
         }
         .contents1 {
         width: 100%;
         }
         .contents1 {
         width: 100%;
         }
         }
      </style>
   </head>
   <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
      <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
         <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
               <td width="100%">
                  <div class="webkit" style="max-width:600px;Margin:0 auto;">
                     <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                        <tr>
                           <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                              <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                 <tr>
                                    <td>
                                       <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                          <tbody>
                                             <tr>
                                                <td align="center">
                                                   <center>
                                                      <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                         <tbody>
                                                            <tr>
                                                               <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                  <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                     <tr>
                                                                        <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                           <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                              <table class="contents" style="border-spacing:0; width:100%">
                                                                                 <tr>
                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                       <a href="#" target="_blank"><img src="" alt="" width="60" height="60" style="border-width:0; max-width:60px;height:auto; display:block" align="left" /></a>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                           <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                              <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                 <tr>
                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                       <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                          <tr>
                                                                                             <td align="left" valign="top">&nbsp;</td>
                                                                                          </tr>
                                                                                          <tr></tr>
                                                                                       </table>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                        </td>
                                                                     </tr>
                                                                     <tr>
                                                                        <td>&nbsp;</td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                         </tbody>
                                                      </table>
                                                   </center>
                                                </td>
                                             </tr>
                                          </tbody>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                              <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                 <tr>
                                    <td align="left" style="padding:50px 50px 50px 50px">
                                       <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                       <h2>##OperationPerformedUser## started the sprint - ##SprintName##(##SprintUniqueName##) from ##SprintStatus##</h2>
                                       </p>
									   <div style="width: 100%;">
									   <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Project name - ##ProjectName##
                                                </p>
													<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Sprint start date - ##SprintStartDate##
                                                </p>
                                                <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Sprint end date - ##SprintEndDate##
                                                </p>
									   </div>

                                       <div style="width: 100%;text-align: center;">
                                          <a style="text-decoration:none;text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff" " href="##siteAddress##">                                                    
                                           <button class="download-button" target="_blank" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;            background-color: #009999;border: none;color: white;padding: 15px 32px;text-align: center;text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px;cursor: pointer; ">
										   Go to ##SprintUniqueName##
										   </button>
										   </a>
									   </div>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                              <br />                                                              Best Regards, <br />                                                              ##footerName##                                                          </p>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                        </tr>
                     </table>
                  </div>
               </td>
            </tr>
         </table>
      </center>
   </body>
</html>',@CompanyId),
('GoalRequestedForReplanEmailTemplate',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <!--[if !mso]><!-->
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <!--<![endif]-->
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title></title>
      <style type="text/css">
         * {
         -webkit-font-smoothing: antialiased;
         }
         body {
         Margin: 0;
         padding: 0;
         min-width: 100%;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         mso-line-height-rule: exactly;
         }
         table {
         border-spacing: 0;
         color: #333333;
         font-family: Arial, sans-serif;
         }
         img {
         border: 0;
         }
         .wrapper {
         width: 100%;
         table-layout: fixed;
         -webkit-text-size-adjust: 100%;
         -ms-text-size-adjust: 100%;
         }
         .webkit {
         max-width: 600px;
         }
         .outer {
         Margin: 0 auto;
         width: 100%;
         max-width: 600px;
         }
         .full-width-image img {
         width: 100%;
         max-width: 600px;
         height: auto;
         }
         .inner {
         padding: 10px;
         }
         p {
         Margin: 0;
         padding-bottom: 10px;
         }
         .h1 {
         font-size: 21px;
         font-weight: bold;
         Margin-top: 15px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .h2 {
         font-size: 18px;
         font-weight: bold;
         Margin-top: 10px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column .contents {
         text-align: left;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column p {
         font-size: 14px;
         Margin-bottom: 10px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .two-column {
         text-align: center;
         font-size: 0;
         }
         .two-column .column {
         width: 100%;
         max-width: 300px;
         display: inline-block;
         vertical-align: top;
         }
         .contents {
         width: 100%;
         }
         .two-column .contents {
         font-size: 14px;
         text-align: left;
         }
         .two-column img {
         width: 100%;
         max-width: 280px;
         height: auto;
         }
         .two-column .text {
         padding-top: 10px;
         }
         .three-column {
         text-align: center;
         font-size: 0;
         padding-top: 10px;
         padding-bottom: 10px;
         }
         .three-column .column {
         width: 100%;
         max-width: 200px;
         display: inline-block;
         vertical-align: top;
         }
         .three-column .contents {
         font-size: 14px;
         text-align: center;
         }
         .three-column img {
         width: 100%;
         max-width: 180px;
         height: auto;
         }
         .three-column .text {
         padding-top: 10px;
         }
         .img-align-vertical img {
         display: inline-block;
         vertical-align: middle;
         }
         .download-button {
         background-color: #009999;
         border: none;
         color: white;
         padding: 15px 32px;
         text-align: center;
         text-decoration: none;
         display: inline-block;
         font-size: 16px;
         margin: 4px 2px;
         cursor: pointer;
         }
         @@media only screen and (max-device-width: 480px) {
         table[class=hide], img[class=hide], td[class=hide] {
         display: none !important;
         }
         .contents1 {
         width: 100%;
         }
         .contents1 {
         width: 100%;
         }
         }
      </style>
   </head>
   <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
      <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
         <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
               <td width="100%">
                  <div class="webkit" style="max-width:600px;Margin:0 auto;">
                     <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                        <tr>
                           <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                              <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                 <tr>
                                    <td>
                                       <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                          <tbody>
                                             <tr>
                                                <td align="center">
                                                   <center>
                                                      <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                         <tbody>
                                                            <tr>
                                                               <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                  <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                     <tr>
                                                                        <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                           <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                              <table class="contents" style="border-spacing:0; width:100%">
                                                                                 <tr>
                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                       <a href="#" target="_blank"><img src=##CompanyLogo## alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                           <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                              <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                 <tr>
                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                       <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                          <tr>
                                                                                             <td align="left" valign="top">&nbsp;</td>
                                                                                          </tr>
                                                                                          <tr></tr>
                                                                                       </table>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                        </td>
                                                                     </tr>
                                                                     <tr>
                                                                        <td>&nbsp;</td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                         </tbody>
                                                      </table>
                                                   </center>
                                                </td>
                                             </tr>
                                          </tbody>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                              <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                 <tr>
                                    <td align="left" style="padding:50px 50px 50px 50px">
                                       <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                       <h2>##OperationPerformedUser## Requested to replan the ##GoalLabel## - ##GoalName##(##GoalUniqueName##) from ##GoalStatus##</h2>
                                       </p>
                                       <div style="width: 100%;text-align: center;">
                                          <a style="text-decoration:none;text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff" " href="##siteAddress##">                      
										  <button class="download-button" target="_blank" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;            background-color: #009999;border: none;color: white;padding: 15px 32px;text-align: center;text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px;cursor: pointer; ">
										     Go to ##GoalUniqueName##
										  </button>   
										  </a>
                                       </div>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                              <br />                                                              Best Regards, <br />                                                              ##footerName##                                                          </p>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                        </tr>
                     </table>
                  </div>
               </td>
            </tr>
         </table>
      </center>
   </body>
</html>',@CompanyId),
('SprintRequestedForReplanEmailTemplate',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <!--[if !mso]><!-->
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <!--<![endif]-->
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title></title>
      <style type="text/css">
         * {
         -webkit-font-smoothing: antialiased;
         }
         body {
         Margin: 0;
         padding: 0;
         min-width: 100%;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         mso-line-height-rule: exactly;
         }
         table {
         border-spacing: 0;
         color: #333333;
         font-family: Arial, sans-serif;
         }
         img {
         border: 0;
         }
         .wrapper {
         width: 100%;
         table-layout: fixed;
         -webkit-text-size-adjust: 100%;
         -ms-text-size-adjust: 100%;
         }
         .webkit {
         max-width: 600px;
         }
         .outer {
         Margin: 0 auto;
         width: 100%;
         max-width: 600px;
         }
         .full-width-image img {
         width: 100%;
         max-width: 600px;
         height: auto;
         }
         .inner {
         padding: 10px;
         }
         p {
         Margin: 0;
         padding-bottom: 10px;
         }
         .h1 {
         font-size: 21px;
         font-weight: bold;
         Margin-top: 15px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .h2 {
         font-size: 18px;
         font-weight: bold;
         Margin-top: 10px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column .contents {
         text-align: left;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column p {
         font-size: 14px;
         Margin-bottom: 10px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .two-column {
         text-align: center;
         font-size: 0;
         }
         .two-column .column {
         width: 100%;
         max-width: 300px;
         display: inline-block;
         vertical-align: top;
         }
         .contents {
         width: 100%;
         }
         .two-column .contents {
         font-size: 14px;
         text-align: left;
         }
         .two-column img {
         width: 100%;
         max-width: 280px;
         height: auto;
         }
         .two-column .text {
         padding-top: 10px;
         }
         .three-column {
         text-align: center;
         font-size: 0;
         padding-top: 10px;
         padding-bottom: 10px;
         }
         .three-column .column {
         width: 100%;
         max-width: 200px;
         display: inline-block;
         vertical-align: top;
         }
         .three-column .contents {
         font-size: 14px;
         text-align: center;
         }
         .three-column img {
         width: 100%;
         max-width: 180px;
         height: auto;
         }
         .three-column .text {
         padding-top: 10px;
         }
         .img-align-vertical img {
         display: inline-block;
         vertical-align: middle;
         }
         .download-button {
         background-color: #009999;
         border: none;
         color: white;
         padding: 15px 32px;
         text-align: center;
         text-decoration: none;
         display: inline-block;
         font-size: 16px;
         margin: 4px 2px;
         cursor: pointer;
         }
         @@media only screen and (max-device-width: 480px) {
         table[class=hide], img[class=hide], td[class=hide] {
         display: none !important;
         }
         .contents1 {
         width: 100%;
         }
         .contents1 {
         width: 100%;
         }
         }
      </style>
   </head>
   <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
      <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
         <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
               <td width="100%">
                  <div class="webkit" style="max-width:600px;Margin:0 auto;">
                     <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                        <tr>
                           <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                              <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                 <tr>
                                    <td>
                                       <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                          <tbody>
                                             <tr>
                                                <td align="center">
                                                   <center>
                                                      <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                         <tbody>
                                                            <tr>
                                                               <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                  <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                     <tr>
                                                                        <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                           <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                              <table class="contents" style="border-spacing:0; width:100%">
                                                                                 <tr>
                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                       <a href="#" target="_blank"><img src=##CompanyLogo## alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                           <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                              <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                 <tr>
                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                       <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                          <tr>
                                                                                             <td align="left" valign="top">&nbsp;</td>
                                                                                          </tr>
                                                                                          <tr></tr>
                                                                                       </table>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                        </td>
                                                                     </tr>
                                                                     <tr>
                                                                        <td>&nbsp;</td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                         </tbody>
                                                      </table>
                                                   </center>
                                                </td>
                                             </tr>
                                          </tbody>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                              <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                 <tr>
                                    <td align="left" style="padding:50px 50px 50px 50px">
                                       <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                       <h2>##OperationPerformedUser## Requested to replan the sprint - ##SprintName##(##SprintUniqueName##) from ##SprintStatus##</h2>
                                       </p>
                                       <div style="width: 100%;text-align: center;">
                                          <a style="text-decoration:none;text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff" " href="##siteAddress##">
										   <button class="download-button" target="_blank" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;            background-color: #009999;border: none;color: white;padding: 15px 32px;text-align: center;text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px;cursor: pointer; ">
                                              Go to ##SprintUniqueName##
										  </button>
										  </a>                       
										                             
                                       </div>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                              <br />                                                              Best Regards, <br />                                                              ##footerName##                                                          </p>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                        </tr>
                     </table>
                  </div>
               </td>
            </tr>
         </table>
      </center>
   </body>
</html>',@CompanyId),
( N'GoalReplanChangesTemplate',
		'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <!--[if !mso]><!-->
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <!--<![endif]-->
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title></title>
      <style type="text/css">
         * {
         -webkit-font-smoothing: antialiased;
         }
         body {
         Margin: 0;
         padding: 0;
         min-width: 100%;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         mso-line-height-rule: exactly;
         }
		 .replanhistorytable {
		    border-collapse: collapse;
		 }
		  .replanhistorytable td,.replanhistorytable th {
		    border: 1px solid #000000;
		  }
         table {
         border-spacing: 0;
         color: #333333;
         font-family: Arial, sans-serif;
         }
         img {
         border: 0;
         }
         .wrapper {
         width: 100%;
         table-layout: fixed;
         -webkit-text-size-adjust: 100%;
         -ms-text-size-adjust: 100%;
         }
         .webkit {
         max-width: 600px;
         }
         .outer {
         Margin: 0 auto;
         width: 100%;
         max-width: 600px;
         }
         .full-width-image img {
         width: 100%;
         max-width: 600px;
         height: auto;
         }
         .inner {
         padding: 10px;
         }
         p {
         Margin: 0;
         padding-bottom: 10px;
         }
         .h1 {
         font-size: 21px;
         font-weight: bold;
         Margin-top: 15px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .h2 {
         font-size: 18px;
         font-weight: bold;
         Margin-top: 10px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column .contents {
         text-align: left;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column p {
         font-size: 14px;
         Margin-bottom: 10px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .two-column {
         text-align: center;
         font-size: 0;
         }
         .two-column .column {
         width: 100%;
         max-width: 300px;
         display: inline-block;
         vertical-align: top;
         }
         .contents {
         width: 100%;
         }
         .two-column .contents {
         font-size: 14px;
         text-align: left;
         }
         .two-column img {
         width: 100%;
         max-width: 280px;
         height: auto;
         }
         .two-column .text {
         padding-top: 10px;
         }
         .three-column {
         text-align: center;
         font-size: 0;
         padding-top: 10px;
         padding-bottom: 10px;
         }
         .three-column .column {
         width: 100%;
         max-width: 200px;
         display: inline-block;
         vertical-align: top;
         }
         .three-column .contents {
         font-size: 14px;
         text-align: center;
         }
         .three-column img {
         width: 100%;
         max-width: 180px;
         height: auto;
         }
         .three-column .text {
         padding-top: 10px;
         }
         .img-align-vertical img {
         display: inline-block;
         vertical-align: middle;
         }
         .download-button {
         background-color: #009999;
         border: none;
         color: white;
         padding: 15px 32px;
         text-align: center;
         text-decoration: none;
         display: inline-block;
         font-size: 16px;
         margin: 4px 2px;
         cursor: pointer;
         }
         @@media only screen and (max-device-width: 480px) {
         table[class=hide], img[class=hide], td[class=hide] {
         display: none !important;
         }
         .contents1 {
         width: 100%;
         }
         .contents1 {
         width: 100%;
         }
         }
      </style>
   </head>
   <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
      <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
         <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
               <td width="100%">
                  <div class="webkit" style="max-width:600px;Margin:0 auto;">
                     <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                        <tr>
                           <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                              <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                 <tr>
                                    <td>
                                       <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                          <tbody>
                                             <tr>
                                                <td align="center">
                                                   <center>
                                                      <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                         <tbody>
                                                            <tr>
                                                               <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                  <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                     <tr>
                                                                        <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                           <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                              <table class="contents" style="border-spacing:0; width:100%">
                                                                                 <tr>
                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                       <a href="#" target="_blank"><img src=##CompanyLogo## alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                           <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                              <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                 <tr>
                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                       <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                          <tr>
                                                                                             <td align="left" valign="top">&nbsp;</td>
                                                                                          </tr>
                                                                                          <tr></tr>
                                                                                       </table>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                        </td>
                                                                     </tr>
                                                                     <tr>
                                                                        <td>&nbsp;</td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                         </tbody>
                                                      </table>
                                                   </center>
                                                </td>
                                             </tr>
                                          </tbody>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                              <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                 <tr>
                                    <td align="left" style="padding:50px 50px 50px 50px">
                                       <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                       <h2>##OperationPerformedUser## replanned the ##Goal## of - ##GoalName##(<a  href="##siteAddress##" target="_blank">##GoalUniqueName##</a>) with the below changes </h2>
                                       </p>
									   <p>##ReplanJson##</p>
                                       
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                              <br />                                                              Best Regards, <br />                                                              ##footerName##                                                          </p>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                        </tr>
                     </table>
                  </div>
               </td>
            </tr>
         </table>
      </center>
   </body>
</html>',@CompanyId),
		(N'SprintReplanChangesTemplate',
		'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <!--[if !mso]><!-->
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <!--<![endif]-->
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title></title>
      <style type="text/css">
         * {
         -webkit-font-smoothing: antialiased;
         }
         body {
         Margin: 0;
         padding: 0;
         min-width: 100%;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         mso-line-height-rule: exactly;
         }
		 .replanhistorytable {
		    border-collapse: collapse;
		 }
		  .replanhistorytable td,.replanhistorytable th {
		    border: 1px solid #000000;
		  }
         table {
         border-spacing: 0;
         color: #333333;
         font-family: Arial, sans-serif;
         }
         img {
         border: 0;
         }
         .wrapper {
         width: 100%;
         table-layout: fixed;
         -webkit-text-size-adjust: 100%;
         -ms-text-size-adjust: 100%;
         }
         .webkit {
         max-width: 600px;
         }
         .outer {
         Margin: 0 auto;
         width: 100%;
         max-width: 600px;
         }
         .full-width-image img {
         width: 100%;
         max-width: 600px;
         height: auto;
         }
         .inner {
         padding: 10px;
         }
         p {
         Margin: 0;
         padding-bottom: 10px;
         }
         .h1 {
         font-size: 21px;
         font-weight: bold;
         Margin-top: 15px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .h2 {
         font-size: 18px;
         font-weight: bold;
         Margin-top: 10px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column .contents {
         text-align: left;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column p {
         font-size: 14px;
         Margin-bottom: 10px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .two-column {
         text-align: center;
         font-size: 0;
         }
         .two-column .column {
         width: 100%;
         max-width: 300px;
         display: inline-block;
         vertical-align: top;
         }
         .contents {
         width: 100%;
         }
         .two-column .contents {
         font-size: 14px;
         text-align: left;
         }
         .two-column img {
         width: 100%;
         max-width: 280px;
         height: auto;
         }
         .two-column .text {
         padding-top: 10px;
         }
         .three-column {
         text-align: center;
         font-size: 0;
         padding-top: 10px;
         padding-bottom: 10px;
         }
         .three-column .column {
         width: 100%;
         max-width: 200px;
         display: inline-block;
         vertical-align: top;
         }
         .three-column .contents {
         font-size: 14px;
         text-align: center;
         }
         .three-column img {
         width: 100%;
         max-width: 180px;
         height: auto;
         }
         .three-column .text {
         padding-top: 10px;
         }
         .img-align-vertical img {
         display: inline-block;
         vertical-align: middle;
         }
         .download-button {
         background-color: #009999;
         border: none;
         color: white;
         padding: 15px 32px;
         text-align: center;
         text-decoration: none;
         display: inline-block;
         font-size: 16px;
         margin: 4px 2px;
         cursor: pointer;
         }
         @@media only screen and (max-device-width: 480px) {
         table[class=hide], img[class=hide], td[class=hide] {
         display: none !important;
         }
         .contents1 {
         width: 100%;
         }
         .contents1 {
         width: 100%;
         }
         }
      </style>
   </head>
   <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
      <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
         <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
               <td width="100%">
                  <div class="webkit" style="max-width:600px;Margin:0 auto;">
                     <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                        <tr>
                           <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                              <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                 <tr>
                                    <td>
                                       <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                          <tbody>
                                             <tr>
                                                <td align="center">
                                                   <center>
                                                      <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                         <tbody>
                                                            <tr>
                                                               <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                  <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                     <tr>
                                                                        <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                           <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                              <table class="contents" style="border-spacing:0; width:100%">
                                                                                 <tr>
                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                       <a href="#" target="_blank"><img src=##CompanyLogo## alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                           <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                              <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                 <tr>
                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                       <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                          <tr>
                                                                                             <td align="left" valign="top">&nbsp;</td>
                                                                                          </tr>
                                                                                          <tr></tr>
                                                                                       </table>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                        </td>
                                                                     </tr>
                                                                     <tr>
                                                                        <td>&nbsp;</td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                         </tbody>
                                                      </table>
                                                   </center>
                                                </td>
                                             </tr>
                                          </tbody>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                              <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                 <tr>
                                    <td align="left" style="padding:50px 50px 50px 50px">
                                       <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                       <h2>##OperationPerformedUser## replanned the sprint of - ##SprintName##(<a  href="##siteAddress##" target="_blank">##SprintUniqueName##</a>) with the below changes </h2>
                                       </p>
									   <p>##ReplanJson##</p>
                                       
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                              <br />                                                              Best Regards, <br />                                                              ##footerName##                                                          </p>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                        </tr>
                     </table>
                  </div>
               </td>
            </tr>
         </table>
      </center>
   </body>
</html>',@CompanyId)

	)
	AS Source ([TemplateName], [HtmlTemplate],CompanyId) 
	ON Target.[TemplateName] = Source.[TemplateName]  
	AND Target.CompanyId = Source.CompanyId  
	WHEN MATCHED THEN 
	UPDATE SET [HtmlTemplate] = Source.[HtmlTemplate];

END
