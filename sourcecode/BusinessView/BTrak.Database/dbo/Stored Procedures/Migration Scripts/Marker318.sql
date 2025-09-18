CREATE PROCEDURE [dbo].[Marker318]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN


MERGE INTO [dbo].[JobOpeningStatus] AS Target 
		USING (VALUES 
		(NEWID(),'Draft','1',@CompanyId, @UserId,GETDATE(),NULL,NULL,NULL,'#404040')
		,(NEWID(),'Active','2',@CompanyId, @UserId,GETDATE(),NULL,NULL,NULL,'#1E90FF')
		,(NEWID(),'Closed','3',@CompanyId, @UserId,GETDATE(),NULL,NULL,NULL,'#008000')
		)
		
		AS Source ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId],[StatusColour])
		ON Target.[Status] = Source.[Status] AND Target.[CompanyId] = Source.[CompanyId]
		WHEN MATCHED THEN 
		UPDATE SET
				   [Status] = Source.[Status],
				   [Order] = Source.[Order],
				   [CompanyId] = Source.[CompanyId],
				   [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId],
				   [InActiveDateTime] = Source.[InActiveDateTime],
				   [UpdatedDateTime]= Source.[UpdatedDateTime],
				   [UpdatedByUserId] = Source.[UpdatedByUserId],
				   [StatusColour] = Source.[StatusColour]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId],[StatusColour]) 
		VALUES ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId],[StatusColour]);	


MERGE INTO [dbo].[HtmlTemplates] AS Target 
        USING ( VALUES 
                 (NEWID(),'CandidateScheduleRemainderTemplate',
        '<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="x-apple-disable-message-reformatting">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Service Confirmation</title>
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
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
        .o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }
        .o_heading, strong, b { font-weight: 700 !important; }
        a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }
      }
    </style>
    
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
                        <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-primary" style="text-decoration: none;outline: none;color: #126de5;"><img src="##CompanyLogo##" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
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
                                <a class="o_text-light" style="text-decoration: none;outline: none;color: #82899a;display: block;padding: 7px 8px;font-weight: bold;"><span style="mso-text-raise: 6px;display: inline;color: #82899a;">##AssigneeName## </span> <img src="images/person-24-light.png" width="24" height="24" alt="" style="max-width: 24px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                    </div>
                    
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
                  <td class="o_bg-ultra_light o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ebf5fa;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                    <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                      <tbody>
                        <tr>
                          <td class="o_sans o_text o_text-white o_bg-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;color: #ffffff;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                            <img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F452935-8736-41C9-BE73-FC4B1E226959" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                          </td>
                        </tr>
                        <tr>
                          <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                        </tr>
                      </tbody>
                    </table>
                    <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">Interview Schedule Remainder</h2>                    
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
                    <p style="margin-top: 0px;margin-bottom: 0px;">You have been scheduled to interview on ##InterviewDate## ##StartTime##.</p>
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
    <!-- footer-white-3cols -->
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
                          Learn more at <a class="o_text-dark_light o_underline" href="https://snovasys.com/" style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> 
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
</html>',
														GETDATE(),@UserId,@CompanyId)
        )
        AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        ON Target.[TemplateName] = Source.[TemplateName]  AND Target.[CompanyId] = Source.[CompanyId]
        WHEN MATCHED THEN 
        UPDATE SET [TemplateName] = Source.[TemplateName],
                   [HtmlTemplate] = Source.[HtmlTemplate],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [CompanyId] = Source.[CompanyId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]);

MERGE INTO [dbo].[HtmlTemplates] AS Target 
        USING ( VALUES 
                 (NEWID(),'HiredDocumentsEmailTemplate',
        '<!doctype html>  
<html lang="en">
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <meta name="x-apple-disable-message-reformatting">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <title>Account New Sign-in</title>
      <style type="text/css">        a { text-decoration: none; outline: none; }        @media (max-width: 649px) {          .o_col-full { max-width: 100% !important; }          .o_col-half { max-width: 50% !important; }          .o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important; overflow: visible !important; width: auto !important; visibility: visible !important; }          .o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }          .o_xs-center { text-align: center !important; }          .o_xs-left { text-align: left !important; }          .o_xs-right { text-align: left !important; }          table.o_xs-left { margin-left: 0 !important; margin-right: auto !important; float: none !important; }          table.o_xs-right { margin-left: auto !important; margin-right: 0 !important; float: none !important; }          table.o_xs-center { margin-left: auto !important; margin-right: auto !important; float: none !important; }          h1.o_heading { font-size: 32px !important; line-height: 41px !important; }          h2.o_heading { font-size: 26px !important; line-height: 37px !important; }          h3.o_heading { font-size: 20px !important; line-height: 30px !important; }          .o_xs-py-md { padding-top: 24px !important; padding-bottom: 24px !important; }          .o_xs-pt-xs { padding-top: 8px !important; }          .o_xs-pb-xs { padding-bottom: 8px !important; }        }        @media screen {          @font-face {            font-family: ''Roboto'';            font-style: normal;            font-weight: 400;            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }          @font-face {            font-family: ''Roboto'';            font-style: normal;            font-weight: 400;            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }          @font-face {            font-family: ''Roboto'';            font-style: normal;            font-weight: 700;            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }          @font-face {            font-family: ''Roboto'';            font-style: normal;            font-weight: 700;            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }          .o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }          .o_heading, strong, b { font-weight: 700 !important; }          a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }        }      </style>
      <!--[if mso]>      
      <style>        table { border-collapse: collapse; }        .o_col { float: left; }      </style>
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
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                                          <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white" style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
                                       </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- hero-white-icon-outline -->      
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                                          <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                                             <tbody>
                                                <tr>
                                                   <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">                              <img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=138EB53F-BAF9-44A8-9DDB-F26FA43D84B9" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">                            </td>
                                                </tr>
                                                <tr>
                                                   <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                                </tr>
                                             </tbody>
                                          </table>
                                          <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;"> </h2>
                                       </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- device-row -->         
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="left" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
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
										    <h5  style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 20px;text-align:start">Hi ##CandidateName## </h5>
										  
                                          <br> 
 <p style="margin-top: 0px;margin-bottom: 0px;text-align:start">Greetings from  ##CompanyName##</p>
</br> 
                                          <p style="margin-top: 0px;margin-bottom: 0px;text-align:start">Welcome to ##CompanyName## ! We are sure you are eagerly waiting the day you will make your entry into the ##CompanyName## family, just as we are preparing to welcome you to our fold. </p>
										  </br>
										   <p style="margin-top: 0px;margin-bottom: 0px;text-align:start">Submission of the following documents is mandatory for joining us.Please do ensure you submit these documents. </p>
										  </br>
                                       <h4 style="margin-top: 0px;margin-bottom: 0px;text-align:start">##Document##</h4>
                                          </p>                    
                                       </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- spacer -->      
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- alert-primary -->           <!-- spacer -->      
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- content -->            <!-- spacer-lg -->      
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-white" style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
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
                        <p style="margin-top: 0px;margin-bottom: 0px;">                            Learn more at <a class="o_text-dark_light o_underline" href="https://snovasys.com/" style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a>                         </p>
                     </div>
                  </div>
                  <!--[if mso]>
               </td>
               <td width="400" align="right" valign="top" style="padding:0px 8px;">
                  <![endif]-->                      
                  <div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                     <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                     <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                        <p style="margin-top: 0px;margin-bottom: 0px;">                            <a class="o_text-dark_light" href="https://www.facebook.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=68BE1104-6486-4C48-92CE-51655C220EC8" width="36" height="36" alt="fb" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                            <a class="o_text-dark_light" href="https://twitter.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=724466D8-BC90-4747-A28D-18D810516738" width="36" height="36" alt="tw" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                            <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F23ACFD-6145-4431-B55A-E117BBF8AD4C" width="36" height="36" alt="ig" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                          </p>
                     </div>
                  </div>
               </td>
            </tr>
         </tbody>
      </table>
   </body>
</html>',
														GETDATE(),@UserId,@CompanyId)
        )
        AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        ON Target.[TemplateName] = Source.[TemplateName]  AND Target.[CompanyId] = Source.[CompanyId]
        WHEN MATCHED THEN 
        UPDATE SET [TemplateName] = Source.[TemplateName],
                   [HtmlTemplate] = Source.[HtmlTemplate],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [CompanyId] = Source.[CompanyId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]);
	
	MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES
        (NEWID(), @RoleId, N'7AA105DD-6C7C-4878-B0EA-DDCC80D37C12', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
		
    )
    AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
    ON Target.Id = Source.Id  
    WHEN MATCHED THEN 
    UPDATE SET [RoleId] = Source.[RoleId],
               [FeatureId] = Source.[FeatureId],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
    VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
	 (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Project Usage Report (Custom)'),'1','ProjectUsageTable','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Resource Usage Report (Custom)'),'1','ResourceUsageReportTable','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
	)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id AND Source.[CustomApplicationId] IS NOT NULL
	WHEN MATCHED THEN
	UPDATE SET [CustomApplicationId] = Source.[CustomApplicationId],
			   [IsDefault] = Source.[IsDefault],	
			   [VisualizationName] = Source.[VisualizationName],	
			   [FilterQuery] = Source.[FilterQuery],	
			   [DefaultColumns] = Source.[DefaultColumns],	
			   [VisualizationType] = Source.[VisualizationType],	
			   [XCoOrdinate] = Source.[XCoOrdinate],	
			   [YCoOrdinate] = Source.[YCoOrdinate],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET AND Source.[CustomApplicationId] IS NOT NULL THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]) VALUES
	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]);

UPDATE CustomAppColumns SET SubQuery = '	SELECT U.FirstName+'' ''+U.SurName EmployeeName,DATEDIFF(MINUTE,cast(ISNULL(SE.Deadline,SW.DeadLine) as time),cast(InTime as time)) [Late in minutes]	
		      FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL		          
			         INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL			      
					        INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL		
								AND ( (ES.ActiveTo IS NOT NULL AND TS.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo)
											              OR (ES.ActiveTo IS NULL AND TS.[Date] >= ES.ActiveFrom)	
														  				      OR (ES.ActiveTo IS NOT NULL AND TS.[Date] <= ES.ActiveTo)) 
						 INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL	
						 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,''@CurrentDateTime''))		
						 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND CAST(SE.ExceptionDate AS date) = CAST(TS.[Date] as date) AND SE.InActiveDateTime IS NULL       	
						 WHERE SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME)) AND TS.[Date] = ''##Date##''	
						      AND U.CompanyId =	''@CompanyId''
							  AND (''@UserId'' = '''' OR ''@UserId'' = U.Id)
							  AND ((''@IsReportingOnly'' = 1 
							  AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
                                                 OR (''@IsMyself''= 1 AND  U.Id  = ''@OperationsPerformedBy'' )	
												 OR (''@IsAll'' = 1))' WHERE ColumnName = 'MorningLateEmployeesCount' 
AND CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Lates trend graph' AND CompanyId = @CompanyId)
 AND CompanyId =  @CompanyId
 
UPDATE CustomAppColumns SET SubQuery = 'SELECT   U.FirstName+'' ''+U.SurName [Employee name], 
       ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(LunchBreakEndTime, ''+00:00'')),0) - 70 [Lunch late in minutes]
	   FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
	   AND U.CompanyId = ''@CompanyId''	
	   WHERE   TS.[Date] = ''##Date##''     
	   AND (''@UserId'' = '''' OR ''@UserId'' = U.Id)
	   AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))	
	     OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
		 OR (''@IsAll'' = 1))	
		 GROUP BY U.FirstName,U.SurName, LunchBreakEndTime,LunchBreakStartTime	
		  HAVING ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(LunchBreakEndTime, ''+00:00'')),0) > 70' WHERE ColumnName = 'AfternoonLateEmployee' 
		  AND CompanyId = @CompanyId AND CustomWidgetId = (SELECT Id FROM  CustomWidgets WHERE CustomWidgetName ='Lates trend graph' AND CompanyId = @CompanyId)

	MERGE INTO [dbo].[CompanySettings] AS Target 
	USING ( VALUES 
	 (NEWID(),'RecruitmentScheduleRemindFrequency','2','Recruitment schedule remind frequency',@CompanyId,GETDATE(),@UserId)
	)
	AS Source ([Id], [Key], [Value],[Description],[CompanyId],[CreatedDateTime], [CreatedByUserId])
	ON Target.[Key] = Source.[Key] AND Target.CompanyId = Source.CompanyId
	WHEN MATCHED THEN
	UPDATE SET [Key] = Source.[Key]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [Key], [Value],[Description],[CompanyId],[CreatedDateTime], [CreatedByUserId]) VALUES
	([Id], [Key], [Value],[Description],[CompanyId],[CreatedDateTime], [CreatedByUserId]);

	MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES
        (NEWID(), @RoleId, N'C8D9C9F2-BFA4-4619-9F96-C3A7177947EF', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
		(NEWID(), @RoleId, N'4B068355-DAFF-412C-A6B4-3133BEB75C6D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
    )
    AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
    ON Target.Id = Source.Id  
    WHEN MATCHED THEN 
    UPDATE SET [RoleId] = Source.[RoleId],
               [FeatureId] = Source.[FeatureId],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
    VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

	MERGE INTO [dbo].[HtmlTemplates] AS Target 
        USING ( VALUES 
                (NEWID(),'InterviewScheduleApprovalTemplate',
        '<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="x-apple-disable-message-reformatting">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Service Confirmation</title>
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
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
        .o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }
        .o_heading, strong, b { font-weight: 700 !important; }
        a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }
      }
    </style>
    
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
                        <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-primary" style="text-decoration: none;outline: none;color: #126de5;"><img src="##CompanyLogo##" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
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
                                <a class="o_text-light" style="text-decoration: none;outline: none;color: #82899a;display: block;padding: 7px 8px;font-weight: bold;"><span style="mso-text-raise: 6px;display: inline;color: #82899a;">##AssigneeName## </span> <img src="images/person-24-light.png" width="24" height="24" alt="" style="max-width: 24px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                    </div>
                    
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
                  <td class="o_bg-ultra_light o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ebf5fa;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                    <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                      <tbody>
                        <tr>
                          <td class="o_sans o_text o_text-white o_bg-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;color: #ffffff;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                            <img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F452935-8736-41C9-BE73-FC4B1E226959" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                          </td>
                        </tr>
                        <tr>
                          <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                        </tr>
                      </tbody>
                    </table>
                    <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">Confirm Interview Schedule</h2>                    
                  </td>
                </tr>
              </tbody>
            </table>
            <!--[if mso]></td></tr></table><![endif]-->
          </td>
        </tr>
      </tbody>
    </table>
    <!-- service-primary -->
    <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
        <tr>
          <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
            <!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
            <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                <tr>
                  <td class="o_re o_bg-primary o_px o_pb-md" align="center" style="font-size: 0;vertical-align: top;background-color: #126de5;padding-left: 16px;padding-right: 16px;padding-bottom: 24px;">
                    <!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                    <div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">
                      <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
                      <div class="o_px-xs o_sans o_text o_text-white o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #ffffff;text-align: left;padding-left: 8px;padding-right: 8px;">
                        <p class="o_mb-xxs" style="margin-top: 0px;margin-bottom: 4px;"><strong>##InterviewRound##</strong></p>
                        <p class="o_text-xs" style="font-size: 14px;line-height: 21px;margin-top: 0px;margin-bottom: 0px;">##InterviewDate## ##InterviewTime##</p>
                      </div>
                    </div>
                    <!--[if mso]></td><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                    <div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">
                      <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
                      <div class="o_px-xs o_right o_xs-center" style="text-align: right;padding-left: 8px;padding-right: 8px;">
                        <table class="o_right o_xs-center" cellspacing="0" cellpadding="0" border="0" role="presentation" style="text-align: right;margin-left: auto;margin-right: 0;">
                          <tbody>
                            <tr>
                              <td class="o_btn o_bg-white o_br o_heading o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #ffffff;border-radius: 4px;">
                                <a class="o_text-primary" href=''##ApprovalUrl##'' style="text-decoration: none;outline: none;color: #126de5;display: block;padding: 12px 24px;mso-text-raise: 3px;">Confirm</a>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                    </div>
                    <!--[if mso]></td></tr></table><![endif]-->
                  </div></td>
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
                    <p style="margin-top: 0px;margin-bottom: 0px;">##Description##</p>
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
    <!-- footer-white-3cols -->
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
                          Learn more at <a class="o_text-dark_light o_underline" href="https://snovasys.com/" style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> 
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
</html>
',
														GETDATE(),@UserId,@CompanyId)
,(NEWID(),'CandidateScheduleRemainderTemplate',
        '<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="x-apple-disable-message-reformatting">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Service Confirmation</title>
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
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
        .o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }
        .o_heading, strong, b { font-weight: 700 !important; }
        a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }
      }
    </style>
    
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
                        <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-primary" style="text-decoration: none;outline: none;color: #126de5;"><img src="##CompanyLogo##" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
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
                                <a class="o_text-light" style="text-decoration: none;outline: none;color: #82899a;display: block;padding: 7px 8px;font-weight: bold;"><span style="mso-text-raise: 6px;display: inline;color: #82899a;">##AssigneeName## </span> <img src="images/person-24-light.png" width="24" height="24" alt="" style="max-width: 24px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                    </div>
                    
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
                  <td class="o_bg-ultra_light o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ebf5fa;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                    <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                      <tbody>
                        <tr>
                          <td class="o_sans o_text o_text-white o_bg-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;color: #ffffff;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                            <img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F452935-8736-41C9-BE73-FC4B1E226959" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                          </td>
                        </tr>
                        <tr>
                          <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                        </tr>
                      </tbody>
                    </table>
                    <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">Interview Schedule Remainder</h2>                    
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
	    <!-- service-primary -->
    <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
        <tr>
          <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
            <!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
            <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                <tr>
                  <td class="o_re o_bg-primary o_px o_pb-md" align="center" style="font-size: 0;vertical-align: top;background-color: #126de5;padding-left: 16px;padding-right: 16px;padding-bottom: 24px;">
                    <!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                    <div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">
                      <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
                      <div class="o_px-xs o_sans o_text o_text-white o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #ffffff;text-align: left;padding-left: 8px;padding-right: 8px;">
                        <p class="o_mb-xxs" style="margin-top: 0px;margin-bottom: 4px;"><strong>##InterviewRound##</strong></p>
                        <p class="o_text-xs" style="font-size: 14px;line-height: 21px;margin-top: 0px;margin-bottom: 0px;">##InterviewDate## ##StartTime##</p>
                      </div>
                    </div>
                    <!--[if mso]></td><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                    <div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">
                      <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
                      <div class="o_px-xs o_right o_xs-center" style="text-align: right;padding-left: 8px;padding-right: 8px;">
                    </div>
                    <!--[if mso]></td></tr></table><![endif]-->
                  </div></td>
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
                    <p style="margin-top: 0px;margin-bottom: 0px;">##Description##</p>
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
    <!-- footer-white-3cols -->
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
                          Learn more at <a class="o_text-dark_light o_underline" href="https://snovasys.com/" style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> 
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
</html>',
														GETDATE(),@UserId,@CompanyId)
        )
        AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        ON Target.[TemplateName] = Source.[TemplateName]  AND Target.[CompanyId] = Source.[CompanyId]
        WHEN MATCHED THEN 
        UPDATE SET [TemplateName] = Source.[TemplateName],
                   [HtmlTemplate] = Source.[HtmlTemplate],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [CompanyId] = Source.[CompanyId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]);

		MERGE INTO [dbo].[FormType] AS Target 
		USING (VALUES 
		(NEWID(), 'Candidate registration form', NULL, @CompanyId, GETDATE(), @UserId)
		)
		AS Source ([Id],[FormTypeName],InActiveDateTime,[CompanyId],[CreatedDateTime],[CreatedByUserId])
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET
				   [FormTypeName] = Source.[FormTypeName],
				   InActiveDateTime = Source.InActiveDateTime,
				   [CompanyId] = Source.[CompanyId],
				   [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id],[FormTypeName],InActiveDateTime,[CompanyId],[CreatedDateTime],[CreatedByUserId]) 
		VALUES ([Id],[FormTypeName],InActiveDateTime,[CompanyId],[CreatedDateTime],[CreatedByUserId]);	

		DECLARE @FormTypeId UNIQUEIDENTIFIER = (SELECT F.Id FROM [FormType] AS F WHERE F.FormTypeName = 'Candidate registration form' AND F.CompanyId = @CompanyId)

		MERGE INTO [dbo].[GenericForm] AS Target 
		USING (VALUES 
				(NEWID(), @FormTypeId, 'Candidate registration form', NULL,
					'{"components":[{"label":"Columns","columns":[{"components":[{"label":"First name","placeholder":"First name","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"FirstName","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Email","placeholder":"Email","tableView":true,"alwaysEnabled":false,"type":"email","input":true,"key":"Email","defaultValue":"","validate":{"required":true,"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false},{"label":"Phone number","placeholder":"Phone number","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"phoneNumber","input":true,"key":"PhoneNumber","defaultValue":"","validate":{"customMessage":"","json":"","required":true},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false},{"label":"Current salary","placeholder":"Current salary","mask":false,"tableView":true,"alwaysEnabled":false,"type":"number","input":true,"key":"CurrentSalary","validate":{"min":0,"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"delimiter":false,"requireDecimal":false,"encrypted":false,"properties":{},"tags":[],"customConditional":"","logic":[],"attributes":{},"reorder":false},{"label":"Current designation","placeholder":"Current designation","mask":false,"tableView":true,"alwaysEnabled":false,"type":"select","input":true,"key":"CurrentDesignation","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","select":false},"conditional":{"show":"","when":"","json":""},"data":{"values":[{"label":"","value":""}]},"valueProperty":"value","selectThreshold":0.3,"encrypted":false,"properties":{},"tags":[],"customConditional":"","logic":[],"attributes":{},"reorder":false,"lazyLoad":false,"selectValues":"","disableLimit":false,"sort":"","reference":false},{"label":"SkypeId","placeholder":"SkypeId","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"SkypeId","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"widget":{"type":""},"properties":{},"tags":[],"reorder":false,"inputFormat":"plain","encrypted":false,"customConditional":"","logic":[],"attributes":{}}],"width":6,"offset":0,"push":0,"pull":0,"type":"column","input":false,"hideOnChildrenHidden":false,"key":"column","tableView":true,"label":"Column"},{"components":[{"label":"Last name","placeholder":"Last name","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"LastName","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Secondary email","placeholder":"Secondary email","tableView":true,"alwaysEnabled":false,"type":"email","input":true,"key":"SecondaryEmail","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false},{"label":"Father name","placeholder":"Father name","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"FatherName","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"properties":{},"tags":[],"widget":{"type":""},"inputFormat":"plain","encrypted":false,"reorder":false,"customConditional":"","logic":[],"attributes":{}},{"label":"Experience in years","placeholder":"Experience in years","mask":false,"tableView":true,"alwaysEnabled":false,"type":"number","input":true,"key":"ExperienceInYears","validate":{"customMessage":"","json":"","min":0},"conditional":{"show":"","when":"","json":""},"properties":{},"tags":[],"delimiter":false,"requireDecimal":false,"encrypted":false,"customConditional":"","logic":[],"attributes":{},"reorder":false},{"label":"Expected salary","placeholder":"Expected salary","mask":false,"tableView":true,"alwaysEnabled":false,"type":"number","input":true,"key":"ExpectedSalary","validate":{"min":0,"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"delimiter":false,"requireDecimal":false,"encrypted":false,"properties":{},"tags":[],"customConditional":"","logic":[],"attributes":{},"reorder":false},{"label":"Reference employeeid","placeholder":"Reference employeeid","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"ReferenceEmployeeId","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"tags":[],"widget":{"type":""},"reorder":false,"customConditional":"","logic":[],"attributes":{}}],"width":6,"offset":0,"push":0,"pull":0,"type":"column","input":false,"hideOnChildrenHidden":false,"key":"column","tableView":true,"label":"Column"}],"mask":false,"tableView":false,"alwaysEnabled":false,"type":"columns","input":false,"key":"columns2","conditional":{"show":"","when":"","json":""},"reorder":false,"properties":{},"customConditional":"","logic":[],"attributes":{}},{"label":"Columns","columns":[{"components":[{"label":"Address street1","placeholder":"Address street1","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"AddressStreet1","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"State","placeholder":"State","mask":false,"tableView":true,"alwaysEnabled":false,"type":"select","input":true,"key":"State","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","select":false},"conditional":{"show":"","when":"","json":""},"data":{"values":[{"label":"","value":""}]},"valueProperty":"value","selectThreshold":0.3,"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false,"lazyLoad":false,"selectValues":"","disableLimit":false,"sort":"","reference":false},{"label":"Zip code","placeholder":"Zip code","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"ZipCode","defaultValue":"","validate":{"pattern":"[0-9]+","customMessage":"","json":"","maxLength":20,"required":true},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"widget":{"type":""},"reorder":false}],"width":6,"offset":0,"push":0,"pull":0,"type":"column","input":false,"hideOnChildrenHidden":false,"key":"column","tableView":true,"label":"Column"},{"components":[{"label":"Address street2","placeholder":"Address street2","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"AddressStreet2","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"widget":{"type":""},"properties":{},"tags":[],"reorder":false,"inputFormat":"plain","encrypted":false,"customConditional":"","logic":[],"attributes":{}},{"label":"Country","placeholder":"Country","mask":false,"tableView":true,"alwaysEnabled":false,"type":"select","input":true,"key":"Country","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","select":false},"conditional":{"show":"","when":"","json":""},"data":{"values":[{"label":"","value":""}]},"valueProperty":"value","selectThreshold":0.3,"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false,"lazyLoad":false,"selectValues":"","disableLimit":false,"sort":"","reference":false}],"width":6,"offset":0,"push":0,"pull":0,"type":"column","input":false,"hideOnChildrenHidden":false,"key":"column","tableView":true,"label":"Column"}],"mask":false,"tableView":false,"alwaysEnabled":false,"type":"columns","input":false,"key":"columns3","conditional":{"show":"","when":"","json":""},"reorder":false,"properties":{},"customConditional":"","logic":[],"attributes":{}},{"label":"Education details","reorder":false,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"editgrid","input":true,"key":"EducationDetails","validate":{"customMessage":"","json":"","required":true},"conditional":{"show":"","when":"","json":""},"components":[{"label":"Institute","placeholder":"Institute","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"Institute","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"widget":{"type":""},"reorder":false},{"label":"Department","placeholder":"Department","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"Department","defaultValue":"","validate":{"customMessage":"","json":"","required":true,"minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Name of degree","placeholder":"Name of degree","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"NameOfDegree","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"unique":true,"widget":{"type":""},"reorder":false},{"label":"From date","hideInputLabels":false,"inputsLabelPosition":"top","fields":{"day":{"placeholder":"Day","hide":false,"type":"number","required":true},"month":{"placeholder":"Month","hide":false,"type":"select","required":true},"year":{"placeholder":"Year","hide":false,"type":"number","required":true}},"useLocaleSettings":true,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"day","input":true,"key":"DateFrom","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"encrypted":false,"maxDate":"","minDate":"","properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false},{"label":"To date","hideInputLabels":false,"inputsLabelPosition":"top","fields":{"day":{"placeholder":"Day","hide":false,"type":"number"},"month":{"placeholder":"Month","hide":false,"type":"select"},"year":{"placeholder":"Year","hide":false,"type":"number"}},"useLocaleSettings":false,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"day","input":true,"key":"DateTo","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"encrypted":false,"maxDate":"","minDate":"","properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false}],"rowClass":"","addAnother":"","modal":false,"saveRow":"","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[]},{"label":"Experience","placeholder":"Experience","reorder":false,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"editgrid","input":true,"key":"Experience","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"components":[{"label":"Occupation title","placeholder":"Occupation title","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"OccupationTitle","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Company name","placeholder":"Company name","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"CompanyName","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Company type","placeholder":"Company type","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"CompanyType","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Description","placeholder":"Description","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"Description","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Date from","hideInputLabels":false,"inputsLabelPosition":"top","fields":{"day":{"placeholder":"Day","hide":false,"type":"number","required":true},"month":{"placeholder":"Month","hide":false,"type":"select","required":true},"year":{"placeholder":"Year","hide":false,"type":"number","required":true}},"useLocaleSettings":true,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"day","input":true,"key":"DateFrom","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"maxDate":"","minDate":"","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false},{"label":"Date to","hideInputLabels":false,"inputsLabelPosition":"top","fields":{"day":{"placeholder":"Day","hide":false,"type":"number","required":true},"month":{"placeholder":"Month","hide":false,"type":"select","required":true},"year":{"placeholder":"Year","hide":false,"type":"number","required":true}},"useLocaleSettings":true,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"day","input":true,"key":"DateTo","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"encrypted":false,"maxDate":"","minDate":"","properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false},{"label":"Location","placeholder":"Location","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"Location","defaultValue":"","validate":{"required":true,"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Salary","placeholder":"Salary","mask":false,"tableView":true,"alwaysEnabled":false,"type":"number","input":true,"key":"Salary","validate":{"required":true,"customMessage":"","json":"","min":0},"conditional":{"show":"","when":"","json":""},"delimiter":false,"requireDecimal":false,"encrypted":false,"properties":{},"tags":[],"customConditional":"","logic":[],"attributes":{},"reorder":false}],"rowClass":"","addAnother":"","modal":false,"saveRow":"","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"templates":{"row":"<div class=\"row\">\n  {% util.eachComponent(components, function(component) { %}\n    {% if (!component.hasOwnProperty(''tableView'') || component.tableView) { %}\n      <div class=\"col-sm-1\">\n        {{ getView(component, row[component.key]) }}\n      </div>\n    {% } %}\n  {% }) %}\n  {% if (!instance.options.readOnly) { %}\n    <div class=\"col\">\n      <div class=\"btn-group pull-right\">\n        <button class=\"btn btn-default btn-light btn-sm editRow\"><i class=\"{{ iconClass(''edit'') }}\"></i></button>\n        <button class=\"btn btn-danger btn-sm removeRow\"><i class=\"{{ iconClass(''trash'') }}\"></i></button>\n      </div>\n    </div>\n  {% } %}\n</div>","header":"<div class=\"row\">\n  {% util.eachComponent(components, function(component) { %}\n    {% if (!component.hasOwnProperty(''tableView'') || component.tableView) { %}\n      <div class=\"col-sm-1\">{{ component.label }}</div>\n    {% } %}\n  {% }) %}\n</div>"}},{"label":"Skills","placeholder":"Skills","reorder":false,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"editgrid","input":true,"key":"Skills","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"components":[{"label":"Skill name","placeholder":"Skill name","mask":false,"tableView":true,"alwaysEnabled":false,"type":"select","input":true,"key":"SkillName","defaultValue":"","validate":{"customMessage":"","json":"","required":true,"select":false},"conditional":{"show":"","when":"","json":""},"data":{"values":[{"label":"","value":""}]},"valueProperty":"value","selectThreshold":0.3,"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false,"lazyLoad":false,"selectValues":"","disableLimit":false,"sort":"","reference":false},{"label":"Experience","placeholder":"Experience","mask":false,"tableView":true,"alwaysEnabled":false,"type":"number","input":true,"key":"Experience","validate":{"required":true,"customMessage":"","json":"","min":0},"conditional":{"show":"","when":"","json":""},"delimiter":false,"requireDecimal":false,"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false}],"rowClass":"","addAnother":"","modal":false,"saveRow":"","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"templates":{"row":"<div class=\"row\">\n  {% util.eachComponent(components, function(component) { %}\n    {% if (!component.hasOwnProperty(''tableView'') || component.tableView) { %}\n      <div class=\"col-sm-2\">\n        {{ getView(component, row[component.key]) }}\n      </div>\n    {% } %}\n  {% }) %}\n  {% if (!instance.options.readOnly) { %}\n    <div class=\"col\">\n      <div class=\"btn-group pull-right\">\n        <button class=\"btn btn-default btn-light btn-sm editRow\"><i class=\"{{ iconClass(''edit'') }}\"></i></button>\n        <button class=\"btn btn-danger btn-sm removeRow\"><i class=\"{{ iconClass(''trash'') }}\"></i></button>\n      </div>\n    </div>\n  {% } %}\n</div>"}},{"label":"Documents","placeholder":"Documents","reorder":false,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"editgrid","input":true,"key":"Documents","validate":{"customMessage":"","json":"","required":true},"conditional":{"show":"","when":"","json":""},"components":[{"label":"Document name","placeholder":"Document name","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"DocumentName","defaultValue":"","validate":{"required":true,"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"unique":true,"widget":{"type":""},"reorder":false},{"label":"Description","placeholder":"Description","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"Description","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Document type","placeholder":"Document type","mask":false,"tableView":true,"alwaysEnabled":false,"type":"select","input":true,"key":"DocumentType","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","select":false},"conditional":{"show":"","when":"","json":""},"data":{"values":[{"label":"","value":""}]},"valueProperty":"value","selectThreshold":0.3,"encrypted":false,"properties":{},"tags":[],"customConditional":"","logic":[],"attributes":{},"reorder":false,"lazyLoad":false,"selectValues":"","disableLimit":false,"sort":"","reference":false},{"label":"Upload document","placeholder":"Upload document","multiple":true,"reorder":false,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"file","input":true,"key":"UploadDocument","defaultValue":[],"validate":{"customMessage":"","json":"","required":true},"conditional":{"show":"","when":"","json":""},"storage":"url","dir":"","fileNameTemplate":"","webcam":false,"fileTypes":[{"label":"","value":""}],"encrypted":false,"customConditional":"","properties":{},"logic":[],"attributes":{},"tags":[],"url":"https://btrak643-development.snovasys.com/backend/File/FileApi/UploadFileForRecruitment?moduleTypeId=15","options":"","webcamSize":""}],"rowClass":"","addAnother":"","modal":false,"saveRow":"","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"templates":{"row":"<div class=\"row\">\n  {% util.eachComponent(components, function(component) { %}\n    {% if (!component.hasOwnProperty(''tableView'') || component.tableView) { %}\n      <div class=\"col-sm-2\">\n        {{ getView(component, row[component.key]) }}\n      </div>\n    {% } %}\n  {% }) %}\n  {% if (!instance.options.readOnly) { %}\n    <div class=\"col\">\n      <div class=\"btn-group pull-right\">\n        <button class=\"btn btn-default btn-light btn-sm editRow\"><i class=\"{{ iconClass(''edit'') }}\"></i></button>\n        <button class=\"btn btn-danger btn-sm removeRow\"><i class=\"{{ iconClass(''trash'') }}\"></i></button>\n      </div>\n    </div>\n  {% } %}\n</div>"}},{"label":"Submit","state":"","theme":"primary","shortcut":"","disableOnInvalid":true,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"button","key":"submit","input":true,"defaultValue":false,"validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"showValidations":false,"event":"","url":"","custom":"","reorder":false}]}'
					, GETDATE(),@UserId, NULL)
				)
		AS Source ([Id],[FormTypeId],[FormName],[WorkflowTrigger],[FormJson],[CreatedDateTime],[CreatedByUserId],[InActiveDateTime])
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET
					[FormTypeId] = Source.[FormTypeId],
					[FormName] = Source.[FormName],
					[WorkflowTrigger] = Source.[WorkflowTrigger],
					[FormJson] = Source.[FormJson],
					[CreatedDateTime] = Source.[CreatedDateTime],
					[CreatedByUserId] = Source.[CreatedByUserId],
					[InActiveDateTime] = Source.[InActiveDateTime]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id],[FormTypeId],[FormName],[WorkflowTrigger],[FormJson],[CreatedDateTime],[CreatedByUserId],[InActiveDateTime]) 
		VALUES ([Id],[FormTypeId],[FormName],[WorkflowTrigger],[FormJson],[CreatedDateTime],[CreatedByUserId],[InActiveDateTime]);	

		MERGE INTO [dbo].[HtmlTemplates] AS Target 
        USING ( VALUES 
                 (NEWID(),'InterviewScheduleConfirmedTemplate',
        '<!doctype html>  
		<html lang="en">    
		<head>     
		<meta charset="utf-8">      
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">      
		<meta name="x-apple-disable-message-reformatting">      
		<meta http-equiv="X-UA-Compatible" content="IE=edge">     
		<title>Service Confirmation</title>     
		<style type="text/css">        a { text-decoration: none; outline: none; }       
		@media (max-width: 649px) {          .o_col-full { max-width: 100% !important; }         
		.o_col-half { max-width: 50% !important; }   
		.o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important overflow: visible !important; width: auto !important; visibility: visible !important; }          
		.o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; 
		line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }         
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
		.o_xs-pb-xs { padding-bottom: 8px !important; }        }       
		@media screen {        
		@font-face {           
		font-family:''Roboto'';           
		font-style: normal;        
		font-weight: 400;        
		src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");        
		unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
		}      
		@font-face 
		{          
		font-family: ''Roboto'';         
		font-style: normal;          
		font-weight: 400;           
		src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");  
		unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
		}         
		@font-face 
		{           
		font-family: ''Roboto'';          
		font-style: normal;      
		font-weight: 700;          
		src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");  
		unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
		}         
		@font-face 
		{           
		font-family: ''Roboto'';     
		font-style: normal;           
		font-weight: 700;      
		src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");     
		unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; 
		}      
		.o_sans, .o_heading { font-family: "Roboto", sans-serif !important; 
		}         
		.o_heading, strong,
		b { font-weight: 700 !important; }        
		a[x-apple-data-detectors]
		{ color: inherit !important; text-decoration: none !important; }    
		}    
		</style>      
		</head>   
		<body class="o_body o_bg-light" style="width: 100%;margin: 0px;padding: 0px;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;background-color: #dbe5ea;">     
		<!-- preview-text -->     
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">     
		<tbody>          
		<tr>        
		<td class="o_hide" align="center" style="display: none;font-size: 0;max-height: 0;width: 0;line-height: 0;overflow: hidden;mso-hide: all;visibility: hidden;">Email Summary (Hidden)
		</td>  
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
		<div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp;
		</div>                     
		<div class="o_px-xs o_sans o_text o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;text-align: left;padding-left: 8px;padding-right: 8px;">           
		<p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-primary" href="https://example.com/" style="text-decoration: none;outline: none;color: #126de5;"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
		</a>
		</p>                      
		</div>                     
		</div>         
		<!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->               
		<div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">             
		<div style="font-size: 22px; line-height: 22px; height: 22px;">&nbsp;
		</div>                   
		<div class="o_px-xs" style="padding-left: 8px;padding-right: 8px;">                       
		<table class="o_right o_xs-center" cellspacing="0" cellpadding="0" border="0" role="presentation" style="text-align: right;margin-left: auto;margin-right: 0;">     
		<tbody>                            
		<tr>                          
		<td class="o_btn-b o_heading o_text-xs" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;mso-padding-alt: 7px 8px;">                   
		<a class="o_text-light" style="text-decoration: none;outline: none;color: #82899a;display: block;padding: 7px 8px;font-weight: bold;">
		<span style="mso-text-raise: 6px;display: inline;color: #82899a;">##AssigneeName## </span> 
		<img src="images/person-24-light.png" width="24" height="24" alt="" style="max-width: 24px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
		</a>                               
		</td>                          
		</tr>                        
		</tbody>                     
		</table>                     
		</div>                  
		</div>                         
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
		<td class="o_bg-ultra_light o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ebf5fa;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">                  
		<table cellspacing="0" cellpadding="0" border="0" role="presentation">                  
		<tbody>       
		<tr>                  
		<td class="o_sans o_text o_text-white o_bg-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;color: #ffffff;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">                    
		<img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F452935-8736-41C9-BE73-FC4B1E226959" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">                     
		</td>                     
		</tr>                    
		<tr>                         
		<td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp;
		</td>                     
		</tr>                    
		</tbody>             
		</table>           
		<h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">Interview Schedule confirmed</h2>                   
		</td>       
		</tr>    
		</tbody>      
		</table>       
		<!--[if mso]></td></tr></table><![endif]-->          
		</td>   
		</tr>     
		</tbody>    
		</table>    
		<!-- service-primary -->    
		<table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">    
		<tbody>     
		<tr>         
		<td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">        
		<!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->       
		<table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">     
		<tbody>          
		<tr>               
		<td class="o_re o_bg-primary o_px o_pb-md" align="center" style="font-size: 0;vertical-align: top;background-color: #126de5;padding-left: 50px;padding-right: 16px;padding-bottom: 24px;">             
		<!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->                 
		<div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">           
		<div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp;
		</div>                    
		<div class="o_px-xs o_sans o_text o_text-white o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #ffffff;text-align: left;padding-left: 8px;padding-right: 8px;">                       
		<p class="o_mb-xxs" style="margin-top: 0px;margin-bottom: 4px;"><strong>##InterviewRound##</strong></p>               
		<p class="o_text-xs" style="font-size: 14px;line-height: 21px;margin-top: 0px;margin-bottom: 0px;">##InterviewDate## ##InterviewTime##</p>                
		</div>                  
		</div>                  
		<!--[if mso]></td><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->                    
		<div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">      
		<div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp;
		</div>                      
		<div class="o_px-xs o_right o_xs-center" style="text-align: right;padding-left: 8px;padding-right: 8px;">        
		<table class="o_right o_xs-center" cellspacing="0" cellpadding="0" border="0" role="presentation" style="text-align: right;margin-left: auto;margin-right: 0;">        
		<tbody>                         
		<tr>                            
		<td class="o_btn o_bg-white o_br o_heading o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #ffffff;border-radius: 4px;">               
		</td>                    
		</tr>                         
		</tbody>                     
		</table>                  
		</div>                   
		<!--[if mso]></td></tr></table><![endif]-->    
		</div>
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
		<tbody>                  <tr>                    <td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">                      <p style="margin-top: 0px;margin-bottom: 0px;">The interview which was scheduled on the above date was confirmed</p>                    </td>                  </tr>                </tbody>              </table>              <!--[if mso]></td></tr></table><![endif]-->            </td>          </tr>        </tbody>      </table>      <!-- spacer -->      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">        <tbody>          <tr>            <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">              <!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">                <tbody>                  <tr>                    <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>                  </tr>                </tbody>              </table>              <!--[if mso]></td></tr></table><![endif]-->            </td>          </tr>        </tbody>      </table>      <!-- footer-white-3cols -->       <table class="o_block-lg" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">                <tbody>                  <tr>                    <td class="o_re o_bg-dark o_px o_pb-lg o_br-b" align="center" style="font-size: 0;vertical-align: top;background-color: #242b3d;border-radius: 0px 0px 4px 4px;padding-left: 16px;padding-right: 16px;padding-bottom: 32px;">                      <div class="o_col o_col-4" style="display: inline-block;vertical-align: top;width: 100%;max-width: 400px;">                        <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>                        <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: left;padding-left: 8px;padding-right: 8px;">                          <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">© 2008-2020 Snovasys. All rights reserved</p>       <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;"> (+44) 07944 144 944    - info@snovasys.com</p>                      <p class="o_mb-xs" style="margin-top: 0px;margin-bottom: 8px;">Vista Centre 50 Salisbury Road London - TW4 6JQ</p>       <p style="margin-top: 0px;margin-bottom: 0px;">                            Learn more at <a class="o_text-dark_light o_underline" href="https://snovasys.com/" style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a>                         </p>                        </div>                      </div>                      <!--[if mso]></td><td width="400" align="right" valign="top" style="padding:0px 8px;"><![endif]-->                      <div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">                        <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>                        <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">                          <p style="margin-top: 0px;margin-bottom: 0px;">                            <a class="o_text-dark_light" href="https://www.facebook.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=68BE1104-6486-4C48-92CE-51655C220EC8" width="36" height="36" alt="fb" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                            <a class="o_text-dark_light" href="https://twitter.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=724466D8-BC90-4747-A28D-18D810516738" width="36" height="36" alt="tw" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                            <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F23ACFD-6145-4431-B55A-E117BBF8AD4C" width="36" height="36" alt="ig" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                          </p>                        </div>                      </div>                     </td>                  </tr>                </tbody>              </table>    </body>  </html>  
													',	GETDATE(),@UserId,@CompanyId)
        )
        AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        ON Target.[TemplateName] = Source.[TemplateName]  AND Target.[CompanyId] = Source.[CompanyId]
        WHEN MATCHED THEN 
        UPDATE SET [TemplateName] = Source.[TemplateName],
                   [HtmlTemplate] = Source.[HtmlTemplate],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [CompanyId] = Source.[CompanyId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]);

		
 MERGE INTO [dbo].[CrmExternalServicesProperties] AS Target 
  USING (VALUES 
  (NEWID(), 'b1a8969c-09e3-4474-9ec7-54d4e9f4dcd0', N'AppSID', N'APc4906c5e7eb2d017df1e498fd20e32d6', @CompanyId, CAST(N'2020-12-17T17:06:26.430' AS DateTime), @UserId)
  ,(NEWID(), 'b1a8969c-09e3-4474-9ec7-54d4e9f4dcd0', N'AuthToken', N'02f02eee759587ba4b6e5a5ce80c85b3', @CompanyId, CAST(N'2020-12-17T07:09:29.653' AS DateTime), @UserId)
  ,(NEWID(), 'b1a8969c-09e3-4474-9ec7-54d4e9f4dcd0', N'APISecret', N'xOGCAcEH3FvOKmkRJbZEDR2hFBJSsXxr', @CompanyId, CAST(N'2020-12-19T05:36:01.753' AS DateTime), @UserId)
  ,(NEWID(), 'b1a8969c-09e3-4474-9ec7-54d4e9f4dcd0', N'APIKey', N'SK39257c5686261cb23f419633e48a67e2', @CompanyId, CAST(N'2020-12-19T05:36:01.753' AS DateTime), @UserId)
  ,(NEWID(), 'b1a8969c-09e3-4474-9ec7-54d4e9f4dcd0', N'AccountSID', N'AC2bdb0e66f286db21803e241b21eb990a', @CompanyId, CAST(N'2020-12-17T07:09:29.653' AS DateTime), @UserId)
 )
  
 AS Source ([Id], [ExternalId], [Name], [Value], [CompanyId], [CreatedDateTime],[CreatedByUserId])
 ON Target.[Id] = Source.[Id] 
 WHEN MATCHED THEN 
 UPDATE SET
    [ExternalId] = Source.[ExternalId],
    [Name] = Source.[Name],
    [Value] = Source.[Value],
    [CompanyId] = Source.[CompanyId],
    [CreatedDateTime] = Source.[CreatedDateTime],
    [CreatedByUserId] = Source.[CreatedByUserId]
 WHEN NOT MATCHED BY TARGET THEN 
 INSERT ([Id], [ExternalId], [Name], [Value], [CompanyId], [CreatedDateTime],[CreatedByUserId]) 
 VALUES ([Id], [ExternalId], [Name], [Value], [CompanyId], [CreatedDateTime],[CreatedByUserId]);

MERGE INTO [dbo].[HtmlTemplates] AS Target 
        USING ( VALUES 
                 (NEWID(),'OfferMailTemplate',
        '<!doctype html>  
<html lang="en">
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <meta name="x-apple-disable-message-reformatting">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <title>Account New Sign-in</title>
      <style type="text/css">        a { text-decoration: none; outline: none; }        @media (max-width: 649px) {          .o_col-full { max-width: 100% !important; }          .o_col-half { max-width: 50% !important; }          .o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important; overflow: visible !important; width: auto !important; visibility: visible !important; }          .o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }          .o_xs-center { text-align: center !important; }          .o_xs-left { text-align: left !important; }          .o_xs-right { text-align: left !important; }          table.o_xs-left { margin-left: 0 !important; margin-right: auto !important; float: none !important; }          table.o_xs-right { margin-left: auto !important; margin-right: 0 !important; float: none !important; }          table.o_xs-center { margin-left: auto !important; margin-right: auto !important; float: none !important; }          h1.o_heading { font-size: 32px !important; line-height: 41px !important; }          h2.o_heading { font-size: 26px !important; line-height: 37px !important; }          h3.o_heading { font-size: 20px !important; line-height: 30px !important; }          .o_xs-py-md { padding-top: 24px !important; padding-bottom: 24px !important; }          .o_xs-pt-xs { padding-top: 8px !important; }          .o_xs-pb-xs { padding-bottom: 8px !important; }        }        @media screen {          @font-face {            font-family: ''Roboto'';            font-style: normal;            font-weight: 400;            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }          @font-face {            font-family: ''Roboto'';            font-style: normal;            font-weight: 400;            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }          @font-face {            font-family: ''Roboto'';            font-style: normal;            font-weight: 700;            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }          @font-face {            font-family: ''Roboto'';            font-style: normal;            font-weight: 700;            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }          .o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }          .o_heading, strong, b { font-weight: 700 !important; }          a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }        }      </style>
      <!--[if mso]>      
      <style>        table { border-collapse: collapse; }        .o_col { float: left; }      </style>
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
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                                          <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white" style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
                                       </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- hero-white-icon-outline -->      
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                                          <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                                             <tbody>
                                                <tr>
                                                   <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">                              <img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=138EB53F-BAF9-44A8-9DDB-F26FA43D84B9" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">                            </td>
                                                </tr>
                                                <tr>
                                                   <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                                </tr>
                                             </tbody>
                                          </table>
                                          <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;"> </h2>
                                       </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- device-row -->         
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="left" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
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
              <h5  style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 20px;text-align:start">Hi ##Candidate## </h5>
            
                                          <br> 
 <p style="margin-top: 0px;margin-bottom: 0px;text-align:start">Greetings from  ##CompanyName##</p>
</br> 
                                          <p style="margin-top: 0px;margin-bottom: 0px;text-align:start">On behalf of the entire company, I’d like to say that it brings me great pleasure to formally offer you.</p>
            </br> 
             <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                <tr>
                  <td class="o_re o_bg-primary o_px o_pb-md" align="center" style="font-size: 0;vertical-align: top;background-color: #126de5;padding-left: 16px;padding-right: 100px;padding-bottom: 24px;">
                    <!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                   
                    <!--[if mso]></td><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                    <div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">
                      <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
                        <table class="o_right o_xs-center" cellspacing="0" cellpadding="0" border="0" role="presentation" style="text-align: right;margin-left: auto;margin-right: 0;">
                          <tbody>
                            <tr>
                              <td class="o_btn o_bg-white o_br o_heading o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #ffffff;border-radius: 4px;">
                                <a class="o_text-primary" href=''##PdfUrl##'' style="text-decoration: none;outline: none;color: #126de5;display: block;padding: 12px 24px;mso-text-raise: 3px;">Download offer letter</a>
                           
          </td>
        </tr>
      </tbody>
    </table>
                                       </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- spacer -->      
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- alert-primary -->           <!-- spacer -->      
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- content -->            <!-- spacer-lg -->      
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-white" style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
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
                        <p style="margin-top: 0px;margin-bottom: 0px;">                            Learn more at <a class="o_text-dark_light o_underline" href="https://snovasys.com/" style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a>                         </p>
                     </div>
                  </div>
                  <!--[if mso]>
               </td>
               <td width="400" align="right" valign="top" style="padding:0px 8px;">
                  <![endif]-->                      
                  <div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                     <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                     <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                        <p style="margin-top: 0px;margin-bottom: 0px;">                            <a class="o_text-dark_light" href="https://www.facebook.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=68BE1104-6486-4C48-92CE-51655C220EC8" width="36" height="36" alt="fb" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                            <a class="o_text-dark_light" href="https://twitter.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=724466D8-BC90-4747-A28D-18D810516738" width="36" height="36" alt="tw" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                            <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F23ACFD-6145-4431-B55A-E117BBF8AD4C" width="36" height="36" alt="ig" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                          </p>
                     </div>
                  </div>
               </td>
            </tr>
         </tbody>
      </table>
   </body>
</html>',
              GETDATE(),@UserId,@CompanyId)
        )
        AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        ON Target.[TemplateName] = Source.[TemplateName]  AND Target.[CompanyId] = Source.[CompanyId]
        WHEN MATCHED THEN 
        UPDATE SET [TemplateName] = Source.[TemplateName],
                   [HtmlTemplate] = Source.[HtmlTemplate],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [CompanyId] = Source.[CompanyId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]);

MERGE INTO [dbo].[JobOpeningStatus] AS Target 
  USING (VALUES 
  (NEWID(),'Draft','1',@CompanyId, @UserId,GETDATE(),NULL,NULL,NULL,'#676767')
  ,(NEWID(),'Active','2',@CompanyId, @UserId,GETDATE(),NULL,NULL,NULL,'#7FFF00')
  ,(NEWID(),'Closed','3',@CompanyId, @UserId,GETDATE(),NULL,NULL,NULL,'#008000')
  )
  
  AS Source ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId],[StatusColour])
  ON Target.[Status] = Source.[Status] AND Target.[CompanyId] = Source.[CompanyId]
  WHEN MATCHED THEN 
  UPDATE SET
       [Status] = Source.[Status],
       [Order] = Source.[Order],
       [CompanyId] = Source.[CompanyId],
       [CreatedDateTime] = Source.[CreatedDateTime],
       [CreatedByUserId] = Source.[CreatedByUserId],
       [InActiveDateTime] = Source.[InActiveDateTime],
       [UpdatedDateTime]= Source.[UpdatedDateTime],
       [UpdatedByUserId] = Source.[UpdatedByUserId],
       [StatusColour] = Source.[StatusColour]
  WHEN NOT MATCHED BY TARGET THEN 
  INSERT ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId],[StatusColour]) 
  VALUES ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId],[StatusColour]);

    MERGE INTO [dbo].[CustomWidgets] AS Target 
 USING ( VALUES 
    (NEWID(), N'Recruiter''s Performance report','This app provides the information about the recruiter performance based on number of candidates filled for a job opening vs number of candidated selected with in the added candidates. User can change the visualization of the app and user can download the information', N'SELECT JobOpeningTitle [Job Name],NoOfOpenings [No Of Openings],(SELECT COUNT(1) FROM CandidateJobOpening CJO JOIN HiringStatus HS ON HS.Id=CJO.HiringStatusId AND CJO.InActiveDateTime IS NULL
     WHERE CJO.JobOpeningId= JO.Id AND HS.[Status]=''On boarding''
     AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(CJO.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                    AND ((ISNULL(@DateTo,@Date) IS NULL OR   CAST(CJO.CreatedDateTime AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
     AND   (''@UserId'' = '''' OR CJO.CreatedByUserId = ''@UserId'')  AND CJO.InActiveDateTime IS NULL
     ) [Hired Candidates] 
     ,(SELECT COUNT(1) FROM CandidateJobOpening CJO 
     WHERE CJO.JobOpeningId= JO.Id 
     AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(CJO.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                    AND ((ISNULL(@DateTo,@Date) IS NULL OR   CAST(CJO.CreatedDateTime AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
     AND   (''@UserId'' = '''' OR CJO.CreatedByUserId = ''@UserId'') AND CJO.InActiveDateTime IS NULL
     ) [Total Candidates] 
     FROM  JobOpening JO
     WHERE CompanyId = ''@CompanyId'' AND JO.InActiveDateTime IS NULL
      AND (''@EmploymentStatusId'' = '''' OR JobTypeId = ''@EmploymentStatusId'')', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime)) 
, (NEWID(), N'Recruiter Performed Events','This app provides the information about the recruiter performed events i.e Job opening add or update,Candidate add or update,interview shedule for a candidate or feedback for candidates. User can download the information',
                 N' SELECT U.FirstName+'' ''+U.SurName [Recruiter Name] ,
                           COUNT(CASE WHEN CH.[Description] IN (''PhoneChanged'',''ExpectedSalaryChanged'',''FatherNameChanged'',''HiringStatusChanged'',''StateAdded'',
                        ''EmailChanged'',''AssignedToManagerChanged'', ''CandidateAdded'',''CandidateSkillsChanged'',''CandidateEducationalDetailsChanged'',''CandidateExperienceDetailsChanged'') THEN 1 END)[Candidates Updated Count],
                        COUNT(CASE WHEN CH.[Description] = ''JobOpeningChanged'' THEN 1 END) [Job Opening Changed Count],
                        COUNT(CASE WHEN CH.[Description] IN (''CandidateInterviewScheduleChanged'',''CandidateInterviewFeedBack'') THEN 1 END) [Interview Schedule And FeedBack Count]
          FROM [User]U LEFT JOIN CandidateHistory CH ON U.Id = CH.CreatedByUserId AND U.InActiveDateTime IS NULL              
          WHERE U.CompanyId = ''@CompanyId''
       AND (''@CandidateId'' = '''' OR CH.CandidateId = ''@CandidateId'')
    AND  (''@UserId'' = '''' OR  U.Id = ''@UserId'')
    AND   (ISNULL(@DateFrom, @Date) IS NULL OR CAST(CH.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
             AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(CH.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,@Date) AS date)))
          GROUP BY U.FirstName+'' ''+U.SurName', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime)) 
  )
 AS Source ([Id],[CustomWidgetName],[Description] , [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
 ON Target.[CustomWidgetName] = Source.[CustomWidgetName] AND Target.[CompanyId] = Source.[CompanyId]
 WHEN MATCHED THEN
 UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
      [WidgetQuery] = Source.[WidgetQuery], 
      [CompanyId] = Source.[CompanyId],
       [Description] =  Source.[Description],
      [CreatedDateTime] = Source.[CreatedDateTime],
      [CreatedByUserId] = Source.[CreatedByUserId]
 WHEN NOT MATCHED BY TARGET THEN 
 INSERT  ([Id], [Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]) VALUES
  ([Id],[Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]);
     
  MERGE INTO [dbo].[CustomAppDetails] AS Target 
 USING ( VALUES 
        (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Recruiter''s Performance report'),'0','Recruiter''s Performance report','bar'   ,NULL,NULL   ,'Job Name','No Of Openings,Hired Candidates,Total Candidates',GETDATE(),@UserId)
       ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Recruiter''s Performance report'),'1','Recruiter''s Performance report','column',NULL,NULL,'Job Name','No Of Openings,Hired Candidates,Total Candidates',GETDATE(),@UserId)
       ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Recruiter Performed Events'),'1','Recruiter Performed Events','column',NULL,NULL,'Recruiter Name','Candidates Updated Count,Job Opening Changed Count,Interview Schedule And FeedBack Count',GETDATE(),@UserId)
       )
 AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
 ON Target.[CustomApplicationId] = Source.[CustomApplicationId] AND  Target.[VisualizationName] = Source.[VisualizationName] AND  Target.[visualizationType] = Source.[visualizationType]
 WHEN MATCHED THEN
 UPDATE SET [CustomApplicationId] = Source.[CustomApplicationId],
      [IsDefault] = Source.[IsDefault], 
      [VisualizationName] = Source.[VisualizationName], 
      [FilterQuery] = Source.[FilterQuery], 
      [DefaultColumns] = Source.[DefaultColumns], 
      [VisualizationType] = Source.[VisualizationType], 
      [XCoOrdinate] = Source.[XCoOrdinate], 
      [YCoOrdinate] = Source.[YCoOrdinate], 
      [CreatedDateTime] = Source.[CreatedDateTime],
      [CreatedByUserId] = Source.[CreatedByUserId]
 WHEN NOT MATCHED BY TARGET AND Source.[CustomApplicationId] IS NOT NULL THEN 
 INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]) VALUES
 ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]);

  MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
USING (VALUES 
   (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Recruiter''s Performance report' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Recruiter Performed Events' AND CompanyId =  @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
 )
AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
ON Target.[WidgetId] = Source.[WidgetId]  AND Target.[ModuleId] = Source.[ModuleId]  
WHEN MATCHED THEN 
UPDATE SET
     [WidgetId] = Source.[WidgetId],
     [ModuleId] = Source.[ModuleId],
     [CreatedDateTime] = Source.[CreatedDateTime],
     [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET AND Source.[WidgetId] IS NOT NULL AND Source.[ModuleId] IS NOT NULL THEN 
INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]); 
 
MERGE INTO [dbo].[HtmlTemplates] AS Target 
        USING ( VALUES 
                 (NEWID(),'OfferMailTemplate',
        '<!doctype html>  
<html lang="en">
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <meta name="x-apple-disable-message-reformatting">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <title>Account New Sign-in</title>
      <style type="text/css">        a { text-decoration: none; outline: none; }        @media (max-width: 649px) {          .o_col-full { max-width: 100% !important; }          .o_col-half { max-width: 50% !important; }          .o_hide-lg { display: inline-block !important; font-size: inherit !important; max-height: none !important; line-height: inherit !important; overflow: visible !important; width: auto !important; visibility: visible !important; }          .o_hide-xs, .o_hide-xs.o_col_i { display: none !important; font-size: 0 !important; max-height: 0 !important; width: 0 !important; line-height: 0 !important; overflow: hidden !important; visibility: hidden !important; height: 0 !important; }          .o_xs-center { text-align: center !important; }          .o_xs-left { text-align: left !important; }          .o_xs-right { text-align: left !important; }          table.o_xs-left { margin-left: 0 !important; margin-right: auto !important; float: none !important; }          table.o_xs-right { margin-left: auto !important; margin-right: 0 !important; float: none !important; }          table.o_xs-center { margin-left: auto !important; margin-right: auto !important; float: none !important; }          h1.o_heading { font-size: 32px !important; line-height: 41px !important; }          h2.o_heading { font-size: 26px !important; line-height: 37px !important; }          h3.o_heading { font-size: 20px !important; line-height: 30px !important; }          .o_xs-py-md { padding-top: 24px !important; padding-bottom: 24px !important; }          .o_xs-pt-xs { padding-top: 8px !important; }          .o_xs-pb-xs { padding-bottom: 8px !important; }        }        @media screen {          @font-face {            font-family: ''Roboto'';            font-style: normal;            font-weight: 400;            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }          @font-face {            font-family: ''Roboto'';            font-style: normal;            font-weight: 400;            src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }          @font-face {            font-family: ''Roboto'';            font-style: normal;            font-weight: 700;            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");            unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }          @font-face {            font-family: ''Roboto'';            font-style: normal;            font-weight: 700;            src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }          .o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }          .o_heading, strong, b { font-weight: 700 !important; }          a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }        }      </style>
      <!--[if mso]>      
      <style>        table { border-collapse: collapse; }        .o_col { float: left; }      </style>
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
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-primary o_px o_py-md o_br-t o_sans o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;border-radius: 4px 4px 0px 0px;padding-left: 16px;padding-right: 16px;padding-top: 24px;padding-bottom: 24px;">
                                          <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-white" style="text-decoration: none;outline: none;color: #ffffff;"><img src="##CompanyLogo##" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
                                       </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- hero-white-icon-outline -->      
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-white o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ffffff;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                                          <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                                             <tbody>
                                                <tr>
                                                   <td class="o_sans o_text o_text-secondary o_b-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #424651;border: 2px solid #126de5;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">                              <img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=138EB53F-BAF9-44A8-9DDB-F26FA43D84B9" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">                            </td>
                                                </tr>
                                                <tr>
                                                   <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                                                </tr>
                                             </tbody>
                                          </table>
                                          <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;"> </h2>
                                       </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- device-row -->         
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="left" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
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
										    <h5  style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 20px;text-align:start">Hi ##Candidate## </h5>
										  
                                          <br> 
 <p style="margin-top: 0px;margin-bottom: 0px;text-align:start">Greetings from  ##CompanyName##</p>
</br> 
                                          <p style="margin-top: 0px;margin-bottom: 0px;text-align:start">On behalf of the entire company, I’d like to say that it brings me great pleasure to formally offer you.</p>
										  </br> 
										   <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                <tr>
                  <td class="o_re o_bg-primary o_px o_pb-md" align="center" style="font-size: 0;vertical-align: top;background-color: #126de5;padding-left: 16px;padding-right: 100px;padding-bottom: 24px;">
                    <!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                   
                    <!--[if mso]></td><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                    <div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">
                      <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
                        <table class="o_right o_xs-center" cellspacing="0" cellpadding="0" border="0" role="presentation" style="text-align: right;margin-left: auto;margin-right: 0;">
                          <tbody>
                            <tr>
                              <td class="o_btn o_bg-white o_br o_heading o_text" align="center" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;mso-padding-alt: 12px 24px;background-color: #ffffff;border-radius: 4px;">
                                <a class="o_text-primary" href=''##PdfUrl##'' style="text-decoration: none;outline: none;color: #126de5;display: block;padding: 12px 24px;mso-text-raise: 3px;">Download offer letter</a>
                           
          </td>
        </tr>
      </tbody>
    </table>
                                       </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- spacer -->      
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- alert-primary -->           <!-- spacer -->      
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-white" style="font-size: 24px;line-height: 24px;height: 24px;background-color: #ffffff;">&nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
               </td>
            </tr>
         </tbody>
      </table>
      <!-- content -->            <!-- spacer-lg -->      
      <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
         <tbody>
            <tr>
               <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
                  <!--[if mso]>
                  <table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation">
                     <tbody>
                        <tr>
                           <td>
                              <![endif]-->              
                              <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
                                 <tbody>
                                    <tr>
                                       <td class="o_bg-white" style="font-size: 48px;line-height: 48px;height: 48px;background-color: #ffffff;">&nbsp; </td>
                                    </tr>
                                 </tbody>
                              </table>
                              <!--[if mso]>
                           </td>
                        </tr>
                  </table>
                  <![endif]-->            
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
                        <p style="margin-top: 0px;margin-bottom: 0px;">                            Learn more at <a class="o_text-dark_light o_underline" href="https://snovasys.com/" style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a>                         </p>
                     </div>
                  </div>
                  <!--[if mso]>
               </td>
               <td width="400" align="right" valign="top" style="padding:0px 8px;">
                  <![endif]-->                      
                  <div class="o_col o_col-2" style="display: inline-block;vertical-align: top;width: 100%;max-width: 200px;">
                     <div style="font-size: 32px; line-height: 32px; height: 32px;">&nbsp; </div>
                     <div class="o_px-xs o_sans o_text-xs o_text-dark_light o_right o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 14px;line-height: 21px;color: #a0a3ab;text-align: right;padding-left: 8px;padding-right: 8px;">
                        <p style="margin-top: 0px;margin-bottom: 0px;">                            <a class="o_text-dark_light" href="https://www.facebook.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=68BE1104-6486-4C48-92CE-51655C220EC8" width="36" height="36" alt="fb" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                            <a class="o_text-dark_light" href="https://twitter.com/snovasys" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=724466D8-BC90-4747-A28D-18D810516738" width="36" height="36" alt="tw" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                            <a class="o_text-dark_light" href="https://www.linkedin.com/company/snovasys/" style="text-decoration: none;outline: none;color: #a0a3ab;"><img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F23ACFD-6145-4431-B55A-E117BBF8AD4C" width="36" height="36" alt="ig" style="max-width: 36px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a><span> &nbsp;</span>                          </p>
                     </div>
                  </div>
               </td>
            </tr>
         </tbody>
      </table>
   </body>
</html>',
														GETDATE(),@UserId,@CompanyId),
(NEWID(),'CandidateScheduleRemainderTemplate',
        '<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="x-apple-disable-message-reformatting">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Service Confirmation</title>
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
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
        .o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }
        .o_heading, strong, b { font-weight: 700 !important; }
        a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }
      }
    </style>
    
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
                        <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-primary" style="text-decoration: none;outline: none;color: #126de5;"><img src="##CompanyLogo##" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
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
                                <a class="o_text-light" style="text-decoration: none;outline: none;color: #82899a;display: block;padding: 7px 8px;font-weight: bold;"><span style="mso-text-raise: 6px;display: inline;color: #82899a;">##AssigneeName## </span> <img src="images/person-24-light.png" width="24" height="24" alt="" style="max-width: 24px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                    </div>
                    
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
                  <td class="o_bg-ultra_light o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ebf5fa;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                    <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                      <tbody>
                        <tr>
                          <td class="o_sans o_text o_text-white o_bg-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;color: #ffffff;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                            <img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F452935-8736-41C9-BE73-FC4B1E226959" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                          </td>
                        </tr>
                        <tr>
                          <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                        </tr>
                      </tbody>
                    </table>
                    <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">Interview Schedule Remainder</h2>                    
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
	    <!-- service-primary -->
    <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
        <tr>
          <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
            <!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
            <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                <tr>
                  <td class="o_re o_bg-primary o_px o_pb-md" align="center" style="font-size: 0;vertical-align: top;background-color: #126de5;padding-left: 16px;padding-right: 16px;padding-bottom: 24px;">
                    <!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                    <div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">
                      <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
                      <div class="o_px-xs o_sans o_text o_text-white o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #ffffff;text-align: left;padding-left: 8px;padding-right: 8px;">
                        <p class="o_mb-xxs" style="margin-top: 0px;margin-bottom: 4px;"><strong>##InterviewRound##</strong></p>
                        <p class="o_text-xs" style="font-size: 14px;line-height: 21px;margin-top: 0px;margin-bottom: 0px;">##InterviewDate## ##StartTime##</p>
                      </div>
                    </div>
                    <!--[if mso]></td><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                    <div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">
                      <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
                      <div class="o_px-xs o_right o_xs-center" style="text-align: right;padding-left: 8px;padding-right: 8px;">
                    </div>
                    <!--[if mso]></td></tr></table><![endif]-->
                  </div></td>
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
                    <p style="margin-top: 0px;margin-bottom: 0px;">##Description##</p>
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
    <!-- footer-white-3cols -->
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
                          Learn more at <a class="o_text-dark_light o_underline" href="https://snovasys.com/" style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> 
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
</html>',
														GETDATE(),@UserId,@CompanyId)
        )
        AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        ON Target.[TemplateName] = Source.[TemplateName]  AND Target.[CompanyId] = Source.[CompanyId]
        WHEN MATCHED THEN 
        UPDATE SET [TemplateName] = Source.[TemplateName],
                   [HtmlTemplate] = Source.[HtmlTemplate],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [CompanyId] = Source.[CompanyId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
        VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]);

		UPDATE [dbo].[GenericForm] SET [FormJson]='{"components":[{"label":"Columns","columns":[{"components":[{"label":"First name","placeholder":"First name","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"FirstName","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Email","placeholder":"Email","tableView":true,"alwaysEnabled":false,"type":"email","input":true,"key":"Email","defaultValue":"","validate":{"required":true,"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false},{"label":"Phone number","placeholder":"Phone number","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"phoneNumber","input":true,"key":"PhoneNumber","defaultValue":"","validate":{"customMessage":"","json":"","required":true},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false},{"label":"Current salary","placeholder":"Current salary","mask":false,"tableView":true,"alwaysEnabled":false,"type":"number","input":true,"key":"CurrentSalary","validate":{"min":0,"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"delimiter":false,"requireDecimal":false,"encrypted":false,"properties":{},"tags":[],"customConditional":"","logic":[],"attributes":{},"reorder":false},{"label":"Current designation","placeholder":"Current designation","mask":false,"tableView":true,"alwaysEnabled":false,"type":"select","input":true,"key":"CurrentDesignation","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","select":false},"conditional":{"show":"","when":"","json":""},"data":{"values":[{"label":"","value":""}]},"valueProperty":"value","selectThreshold":0.3,"encrypted":false,"properties":{},"tags":[],"customConditional":"","logic":[],"attributes":{},"reorder":false,"lazyLoad":false,"selectValues":"","disableLimit":false,"sort":"","reference":false},{"label":"SkypeId","placeholder":"SkypeId","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"SkypeId","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"widget":{"type":""},"properties":{},"tags":[],"reorder":false,"inputFormat":"plain","encrypted":false,"customConditional":"","logic":[],"attributes":{}}],"width":6,"offset":0,"push":0,"pull":0,"type":"column","input":false,"hideOnChildrenHidden":false,"key":"column","tableView":true,"label":"Column"},{"components":[{"label":"Last name","placeholder":"Last name","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"LastName","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Secondary email","placeholder":"Secondary email","tableView":true,"alwaysEnabled":false,"type":"email","input":true,"key":"SecondaryEmail","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false},{"label":"Father name","placeholder":"Father name","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"FatherName","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"properties":{},"tags":[],"widget":{"type":""},"inputFormat":"plain","encrypted":false,"reorder":false,"customConditional":"","logic":[],"attributes":{}},{"label":"Experience in years","placeholder":"Experience in years","mask":false,"tableView":true,"alwaysEnabled":false,"type":"number","input":true,"key":"ExperienceInYears","validate":{"customMessage":"","json":"","min":0},"conditional":{"show":"","when":"","json":""},"properties":{},"tags":[],"delimiter":false,"requireDecimal":false,"encrypted":false,"customConditional":"","logic":[],"attributes":{},"reorder":false},{"label":"Expected salary","placeholder":"Expected salary","mask":false,"tableView":true,"alwaysEnabled":false,"type":"number","input":true,"key":"ExpectedSalary","validate":{"min":0,"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"delimiter":false,"requireDecimal":false,"encrypted":false,"properties":{},"tags":[],"customConditional":"","logic":[],"attributes":{},"reorder":false},{"label":"Reference employeeid","placeholder":"Reference employeeid","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"ReferenceEmployeeId","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"tags":[],"widget":{"type":""},"reorder":false,"customConditional":"","logic":[],"attributes":{}}],"width":6,"offset":0,"push":0,"pull":0,"type":"column","input":false,"hideOnChildrenHidden":false,"key":"column","tableView":true,"label":"Column"}],"mask":false,"tableView":false,"alwaysEnabled":false,"type":"columns","input":false,"key":"columns2","conditional":{"show":"","when":"","json":""},"reorder":false,"properties":{},"customConditional":"","logic":[],"attributes":{}},{"label":"Columns","columns":[{"components":[{"label":"Address street1","placeholder":"Address street1","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"AddressStreet1","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"State","placeholder":"State","mask":false,"tableView":true,"alwaysEnabled":false,"type":"select","input":true,"key":"State","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","select":false},"conditional":{"show":"","when":"","json":""},"data":{"values":[{"label":"","value":""}]},"valueProperty":"value","selectThreshold":0.3,"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false,"lazyLoad":false,"selectValues":"","disableLimit":false,"sort":"","reference":false},{"label":"Zip code","placeholder":"Zip code","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"ZipCode","defaultValue":"","validate":{"pattern":"[0-9]+","customMessage":"","json":"","maxLength":20,"required":true},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"widget":{"type":""},"reorder":false}],"width":6,"offset":0,"push":0,"pull":0,"type":"column","input":false,"hideOnChildrenHidden":false,"key":"column","tableView":true,"label":"Column"},{"components":[{"label":"Address street2","placeholder":"Address street2","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"AddressStreet2","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"widget":{"type":""},"properties":{},"tags":[],"reorder":false,"inputFormat":"plain","encrypted":false,"customConditional":"","logic":[],"attributes":{}},{"label":"Country","placeholder":"Country","mask":false,"tableView":true,"alwaysEnabled":false,"type":"select","input":true,"key":"Country","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","select":false},"conditional":{"show":"","when":"","json":""},"data":{"values":[{"label":"","value":""}]},"valueProperty":"value","selectThreshold":0.3,"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false,"lazyLoad":false,"selectValues":"","disableLimit":false,"sort":"","reference":false}],"width":6,"offset":0,"push":0,"pull":0,"type":"column","input":false,"hideOnChildrenHidden":false,"key":"column","tableView":true,"label":"Column"}],"mask":false,"tableView":false,"alwaysEnabled":false,"type":"columns","input":false,"key":"columns3","conditional":{"show":"","when":"","json":""},"reorder":false,"properties":{},"customConditional":"","logic":[],"attributes":{}},{"label":"Education details","reorder":false,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"editgrid","input":true,"key":"EducationDetails","validate":{"customMessage":"","json":"","required":true},"conditional":{"show":"","when":"","json":""},"components":[{"label":"Institute","placeholder":"Institute","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"Institute","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"widget":{"type":""},"reorder":false},{"label":"Department","placeholder":"Department","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"Department","defaultValue":"","validate":{"customMessage":"","json":"","required":true,"minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Name of degree","placeholder":"Name of degree","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"NameOfDegree","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"unique":true,"widget":{"type":""},"reorder":false},{"label":"From date","hideInputLabels":false,"inputsLabelPosition":"top","fields":{"day":{"placeholder":"Day","hide":false,"type":"number","required":true},"month":{"placeholder":"Month","hide":false,"type":"select","required":true},"year":{"placeholder":"Year","hide":false,"type":"number","required":true}},"useLocaleSettings":true,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"day","input":true,"key":"DateFrom","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"encrypted":false,"maxDate":"","minDate":"","properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false},{"label":"To date","hideInputLabels":false,"inputsLabelPosition":"top","fields":{"day":{"placeholder":"Day","hide":false,"type":"number"},"month":{"placeholder":"Month","hide":false,"type":"select"},"year":{"placeholder":"Year","hide":false,"type":"number"}},"useLocaleSettings":false,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"day","input":true,"key":"DateTo","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"encrypted":false,"maxDate":"","minDate":"","properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false}],"rowClass":"","addAnother":"","modal":false,"saveRow":"","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[]},{"label":"Experience","placeholder":"Experience","reorder":false,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"editgrid","input":true,"key":"Experience","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"components":[{"label":"Occupation title","placeholder":"Occupation title","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"OccupationTitle","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Company name","placeholder":"Company name","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"CompanyName","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Company type","placeholder":"Company type","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"CompanyType","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Description","placeholder":"Description","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"Description","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Date from","hideInputLabels":false,"inputsLabelPosition":"top","fields":{"day":{"placeholder":"Day","hide":false,"type":"number","required":true},"month":{"placeholder":"Month","hide":false,"type":"select","required":true},"year":{"placeholder":"Year","hide":false,"type":"number","required":true}},"useLocaleSettings":true,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"day","input":true,"key":"DateFrom","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"maxDate":"","minDate":"","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false},{"label":"Date to","hideInputLabels":false,"inputsLabelPosition":"top","fields":{"day":{"placeholder":"Day","hide":false,"type":"number","required":true},"month":{"placeholder":"Month","hide":false,"type":"select","required":true},"year":{"placeholder":"Year","hide":false,"type":"number","required":true}},"useLocaleSettings":true,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"day","input":true,"key":"DateTo","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"encrypted":false,"maxDate":"","minDate":"","properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false},{"label":"Location","placeholder":"Location","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"Location","defaultValue":"","validate":{"required":true,"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Salary","placeholder":"Salary","mask":false,"tableView":true,"alwaysEnabled":false,"type":"number","input":true,"key":"Salary","validate":{"required":true,"customMessage":"","json":"","min":0},"conditional":{"show":"","when":"","json":""},"delimiter":false,"requireDecimal":false,"encrypted":false,"properties":{},"tags":[],"customConditional":"","logic":[],"attributes":{},"reorder":false}],"rowClass":"","addAnother":"","modal":false,"saveRow":"","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"templates":{"row":"<div class=\"row\">\n  {% util.eachComponent(components, function(component) { %}\n    {% if (!component.hasOwnProperty(''tableView'') || component.tableView) { %}\n      <div class=\"col-sm-1\">\n        {{ getView(component, row[component.key]) }}\n      </div>\n    {% } %}\n  {% }) %}\n  {% if (!instance.options.readOnly) { %}\n    <div class=\"col\">\n      <div class=\"btn-group pull-right\">\n        <button class=\"btn btn-default btn-light btn-sm editRow\"><i class=\"{{ iconClass(''edit'') }}\"></i></button>\n        <button class=\"btn btn-danger btn-sm removeRow\"><i class=\"{{ iconClass(''trash'') }}\"></i></button>\n      </div>\n    </div>\n  {% } %}\n</div>","header":"<div class=\"row\">\n  {% util.eachComponent(components, function(component) { %}\n    {% if (!component.hasOwnProperty(''tableView'') || component.tableView) { %}\n      <div class=\"col-sm-1\">{{ component.label }}</div>\n    {% } %}\n  {% }) %}\n</div>"}},{"label":"Skills","placeholder":"Skills","reorder":false,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"editgrid","input":true,"key":"Skills","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"components":[{"label":"Skill name","placeholder":"Skill name","mask":false,"tableView":true,"alwaysEnabled":false,"type":"select","input":true,"key":"SkillName","defaultValue":"","validate":{"customMessage":"","json":"","required":true,"select":false},"conditional":{"show":"","when":"","json":""},"data":{"values":[{"label":"","value":""}]},"valueProperty":"value","selectThreshold":0.3,"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false,"lazyLoad":false,"selectValues":"","disableLimit":false,"sort":"","reference":false},{"label":"Experience","placeholder":"Experience","mask":false,"tableView":true,"alwaysEnabled":false,"type":"number","input":true,"key":"Experience","validate":{"required":true,"customMessage":"","json":"","min":0},"conditional":{"show":"","when":"","json":""},"delimiter":false,"requireDecimal":false,"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"reorder":false}],"rowClass":"","addAnother":"","modal":false,"saveRow":"","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"templates":{"row":"<div class=\"row\">\n  {% util.eachComponent(components, function(component) { %}\n    {% if (!component.hasOwnProperty(''tableView'') || component.tableView) { %}\n      <div class=\"col-sm-2\">\n        {{ getView(component, row[component.key]) }}\n      </div>\n    {% } %}\n  {% }) %}\n  {% if (!instance.options.readOnly) { %}\n    <div class=\"col\">\n      <div class=\"btn-group pull-right\">\n        <button class=\"btn btn-default btn-light btn-sm editRow\"><i class=\"{{ iconClass(''edit'') }}\"></i></button>\n        <button class=\"btn btn-danger btn-sm removeRow\"><i class=\"{{ iconClass(''trash'') }}\"></i></button>\n      </div>\n    </div>\n  {% } %}\n</div>"}},{"label":"Documents","placeholder":"Documents","reorder":false,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"editgrid","input":true,"key":"Documents","validate":{"customMessage":"","json":"","required":true},"conditional":{"show":"","when":"","json":""},"components":[{"label":"Document name","placeholder":"Document name","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"DocumentName","defaultValue":"","validate":{"required":true,"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"unique":true,"widget":{"type":""},"reorder":false},{"label":"Description","placeholder":"Description","allowMultipleMasks":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"Description","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","minLength":1},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"widget":{"type":""},"tags":[],"reorder":false},{"label":"Document type","placeholder":"Document type","mask":false,"tableView":true,"alwaysEnabled":false,"type":"select","input":true,"key":"DocumentType","defaultValue":"","validate":{"required":true,"customMessage":"","json":"","select":false},"conditional":{"show":"","when":"","json":""},"data":{"values":[{"label":"","value":""}]},"valueProperty":"value","selectThreshold":0.3,"encrypted":false,"properties":{},"tags":[],"customConditional":"","logic":[],"attributes":{},"reorder":false,"lazyLoad":false,"selectValues":"","disableLimit":false,"sort":"","reference":false},{"label":"Upload document","placeholder":"Upload document","multiple":true,"reorder":false,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"file","input":true,"key":"UploadDocument","defaultValue":[],"validate":{"customMessage":"","json":"","required":true},"conditional":{"show":"","when":"","json":""},"storage":"url","dir":"","fileNameTemplate":"","webcam":false,"fileTypes":[{"label":"","value":""}],"encrypted":false,"customConditional":"","properties":{},"logic":[],"attributes":{},"tags":[],"url":"https://btrak643-development.snovasys.com/backend/File/FileApi/UploadFileForRecruitment?moduleTypeId=15","options":"","webcamSize":""}],"rowClass":"","addAnother":"","modal":false,"saveRow":"","encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"tags":[],"templates":{"row":"<div class=\"row\">\n  {% util.eachComponent(components, function(component) { %}\n    {% if (!component.hasOwnProperty(''tableView'') || component.tableView) { %}\n      <div class=\"col-sm-2\">\n        {{ getView(component, row[component.key]) }}\n      </div>\n    {% } %}\n  {% }) %}\n  {% if (!instance.options.readOnly) { %}\n    <div class=\"col\">\n      <div class=\"btn-group pull-right\">\n        <button class=\"btn btn-default btn-light btn-sm editRow\"><i class=\"{{ iconClass(''edit'') }}\"></i></button>\n        <button class=\"btn btn-danger btn-sm removeRow\"><i class=\"{{ iconClass(''trash'') }}\"></i></button>\n      </div>\n    </div>\n  {% } %}\n</div>"}},{"label":"Submit","state":"","theme":"primary","shortcut":"","disableOnInvalid":true,"mask":false,"tableView":true,"alwaysEnabled":false,"type":"button","key":"submit","input":true,"defaultValue":false,"validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"encrypted":false,"properties":{},"customConditional":"","logic":[],"attributes":{},"showValidations":false,"event":"","url":"","custom":"","reorder":false}]}'
	FROM [GenericForm] AS G
		JOIN [FormType] AS F ON F.Id = G.FormTypeId AND F.CompanyId = @CompanyId
	WHERE [FormName] = 'Candidate registration form' AND F.CompanyId = @CompanyId

	
MERGE INTO [dbo].[JobOpeningStatus] AS Target 
  USING (VALUES 
  (NEWID(),'Draft','1',@CompanyId, @UserId,GETDATE(),NULL,NULL,NULL,'#676767')
  ,(NEWID(),'Active','2',@CompanyId, @UserId,GETDATE(),NULL,NULL,NULL,'#7FFF00')
  ,(NEWID(),'Closed','3',@CompanyId, @UserId,GETDATE(),NULL,NULL,NULL,'#008000')
  )
  
  AS Source ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId],[StatusColour])
  ON Target.[Status] = Source.[Status] AND Target.[CompanyId] = Source.[CompanyId]
  WHEN MATCHED THEN 
  UPDATE SET
       [Status] = Source.[Status],
       [Order] = Source.[Order],
       [StatusColour] = Source.[StatusColour]
  WHEN NOT MATCHED BY TARGET THEN 
  INSERT ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId],[StatusColour]) 
  VALUES ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId],[StatusColour]);

         UPDATE CustomWidgets SET WidgetQuery = 'SELECT JobOpeningTitle [Job Name],NoOfOpenings [No Of Openings],(SELECT COUNT(1) FROM CandidateJobOpening CJO JOIN HiringStatus HS ON HS.Id=CJO.HiringStatusId AND CJO.InActiveDateTime IS NULL
					WHERE CJO.JobOpeningId= JO.Id AND HS.[Status]=''On boarding''
					AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(CJO.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                    AND ((ISNULL(@DateTo,@Date) IS NULL OR   CAST(CJO.CreatedDateTime AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
					AND   (''@UserId'' = '''' OR CJO.CreatedByUserId = ''@UserId'')  AND (''@CandidateId'' = '''' OR CandidateId = ''@CandidateId'') AND CJO.InActiveDateTime IS NULL
					) [Hired Candidates] 
					,(SELECT COUNT(1) FROM CandidateJobOpening CJO 
					WHERE CJO.JobOpeningId= JO.Id 
					AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(CJO.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                    AND ((ISNULL(@DateTo,@Date) IS NULL OR   CAST(CJO.CreatedDateTime AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
					AND   (''@UserId'' = '''' OR CJO.CreatedByUserId = ''@UserId'')  AND (''@CandidateId'' = '''' OR CandidateId = ''@CandidateId'') AND CJO.InActiveDateTime IS NULL
					) [Total Candidates] 
					FROM  JobOpening JO LEFT JOIN CandidateJobOpening CJO ON CJO.JobOpeningId = JO.Id AND CJO.InActiveDateTime IS NULL
					WHERE CompanyId = ''@CompanyId'' AND JO.InActiveDateTime IS NULL
						AND (''@EmploymentStatusId'' = '''' OR JobTypeId = ''@EmploymentStatusId'')
						AND (''@CandidateId'' = '''' OR CandidateId = ''@CandidateId'')
						AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(JO.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                        AND ((ISNULL(@DateTo,@Date) IS NULL OR   CAST(JO.CreatedDateTime AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
                GROUP BY JobOpeningTitle,NoOfOpenings,JO.Id' WHERE CustomWidgetName = 'Recruiter''s Performance report' AND CompanyId = @CompanyId


	UPDATE [dbo].[HtmlTemplates]
	SET [HtmlTemplate] = '<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="x-apple-disable-message-reformatting">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Service Confirmation</title>
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
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 400;
          src: local("Roboto"), local("Roboto-Regular"), url(https://fonts.gstatic.com/s/roboto/v18/KFOmCnqEu92Fr1Mu4mxK.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format("woff2");
          unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF; }
        @font-face {
          font-family: ''Roboto'';
          font-style: normal;
          font-weight: 700;
          src: local("Roboto Bold"), local("Roboto-Bold"), url(https://fonts.gstatic.com/s/roboto/v18/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format("woff2");
          unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD; }
        .o_sans, .o_heading { font-family: "Roboto", sans-serif !important; }
        .o_heading, strong, b { font-weight: 700 !important; }
        a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }
      }
    </style>
    
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
                        <p style="margin-top: 0px;margin-bottom: 0px;"><a class="o_text-primary" style="text-decoration: none;outline: none;color: #126de5;"><img src="##CompanyLogo##" width="136" height="36" style="max-width: 136px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a></p>
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
                                <a class="o_text-light" style="text-decoration: none;outline: none;color: #82899a;display: block;padding: 7px 8px;font-weight: bold;"><span style="mso-text-raise: 6px;display: inline;color: #82899a;">##AssigneeName## </span> <img src="images/person-24-light.png" width="24" height="24" alt="" style="max-width: 24px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;"></a>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                    </div>
                    
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
                  <td class="o_bg-ultra_light o_px-md o_py-xl o_xs-py-md o_sans o_text-md o_text-light" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 19px;line-height: 28px;background-color: #ebf5fa;color: #82899a;padding-left: 24px;padding-right: 24px;padding-top: 64px;padding-bottom: 64px;">
                    <table cellspacing="0" cellpadding="0" border="0" role="presentation">
                      <tbody>
                        <tr>
                          <td class="o_sans o_text o_text-white o_bg-primary o_px o_py o_br-max" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #126de5;color: #ffffff;border-radius: 96px;padding-left: 16px;padding-right: 16px;padding-top: 16px;padding-bottom: 16px;">
                            <img src="https://snovasys.snovasys.io/backend/File/FileApi/GetGenericFileDetails?fileId=2F452935-8736-41C9-BE73-FC4B1E226959" width="48" height="48" alt="" style="max-width: 48px;-ms-interpolation-mode: bicubic;vertical-align: middle;border: 0;line-height: 100%;height: auto;outline: none;text-decoration: none;">
                          </td>
                        </tr>
                        <tr>
                          <td style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </td>
                        </tr>
                      </tbody>
                    </table>
                    <h2 class="o_heading o_text-dark o_mb-xxs" style="font-family: Helvetica, Arial, sans-serif;font-weight: bold;margin-top: 0px;margin-bottom: 4px;color: #242b3d;font-size: 30px;line-height: 39px;">Interview Schedule Remainder</h2>                    
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
	    <!-- service-primary -->
    <table width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation">
      <tbody>
        <tr>
          <td class="o_bg-light o_px-xs" align="center" style="background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;">
            <!--[if mso]><table width="632" cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td><![endif]-->
            <table class="o_block" width="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="max-width: 632px;margin: 0 auto;">
              <tbody>
                <tr>
                  <td class="o_re o_bg-primary o_px o_pb-md" align="center" style="font-size: 0;vertical-align: top;background-color: #126de5;padding-left: 16px;padding-right: 16px;padding-bottom: 24px;">
                    <!--[if mso]><table cellspacing="0" cellpadding="0" border="0" role="presentation"><tbody><tr><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                    <div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">
                      <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
                      <div class="o_px-xs o_sans o_text o_text-white o_left o_xs-center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;color: #ffffff;text-align: left;padding-left: 8px;padding-right: 8px;">
                        <p class="o_mb-xxs" style="margin-top: 0px;margin-bottom: 4px;"><strong>##InterviewRound##</strong></p>
                        <p class="o_text-xs" style="font-size: 14px;line-height: 21px;margin-top: 0px;margin-bottom: 0px;">##InterviewDate## ##StartTime##</p>
                      </div>
                    </div>
                    <!--[if mso]></td><td width="300" align="center" valign="top" style="padding: 0px 8px;"><![endif]-->
                    <div class="o_col o_col-3" style="display: inline-block;vertical-align: top;width: 100%;max-width: 300px;">
                      <div style="font-size: 24px; line-height: 24px; height: 24px;">&nbsp; </div>
                      <div class="o_px-xs o_right o_xs-center" style="text-align: right;padding-left: 8px;padding-right: 8px;">
                    </div>
                    <!--[if mso]></td></tr></table><![endif]-->
                  </div></td>
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
                    <p style="margin-top: 0px;margin-bottom: 0px;">##Description##</p>
                  </td>
                </tr>
				<tr>
					<td class="o_bg-white o_px-md o_py o_sans o_text o_text-secondary" align="center" style="font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 16px;">
						<p style="margin-top: 0px;margin-bottom: 0px;">##JoinDescription##</p>
					</td>
				</tr
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
    <!-- footer-white-3cols -->
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
                          Learn more at <a class="o_text-dark_light o_underline" href="https://snovasys.com/" style="text-decoration: underline;outline: none;color: #dbe5ea;">snovasys.com</a> 
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
</html>'
	WHERE [TemplateName] = 'CandidateScheduleRemainderTemplate' AND CompanyId = @CompanyId

END
GO