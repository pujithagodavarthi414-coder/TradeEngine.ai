CREATE PROCEDURE [dbo].[Marker292]
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
						<h1 class="o_heading o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;font-size: 36px;line-height: 47px;">Thank you and congratulations for choosing ##footerName##</h1>
						<p style="margin-top: 0px;margin-bottom: 0px;">We are really excited you''ve joined ##footerName##.</p>
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
						<a target="_blank" href="##siteAddress##" style="color:#5fb92a;font-weight:bold;text-decoration:underline" >##footerName## Link</a>
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
						<h1 class="o_heading o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;font-size: 36px;line-height: 47px;">Thank you and congratulations for choosing ##footerName## </h1>
						<p style="margin-top: 0px;margin-bottom: 0px;">We are really excited you''ve joined ##footerName##.</p>
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
						  <li><p><em></em><a target="_blank" href="https://snovasys.com/Documents/SnovasysTerms.pdf" style="color:#5fb92a;font-weight:bold;text-decoration:underline">Terms and Conditions</a> Please go through this link and find the terms and conditions of ##footerName##.</p></li>				     
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
						<p style="margin-top: 0px;margin-bottom: 0px;">Thank you and congratulations for choosing ##footerName##.</p>
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
                                                            Thank you for choosing ##footerName## .Hope you have a great success in the coming future.We are creating your site, once it is finished, we will let you know.Please go through the below link and find the terms and conditions of ##footerName##<br />
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
END
