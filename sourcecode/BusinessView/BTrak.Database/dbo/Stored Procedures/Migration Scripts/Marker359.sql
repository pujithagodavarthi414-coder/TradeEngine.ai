CREATE PROCEDURE [dbo].[Marker359]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

	    DECLARE @Currentdate DATETIME = GETDATE()
MERGE INTO [dbo].[HtmlTemplates] AS Target 
USING ( VALUES 

(NEWID(),'SCO Template',
'<!DOCTYPE html>
<html>
<style>
    .div {
        box-sizing: border-box;
    }

    .p-1 {
        padding: 1rem !important;
    }
    p,table {
    font-family: Verdana, Geneva, sans-serif
    }
    .form-v-table {border: 1px solid #dddddd;text-align: left;padding: 8px;}
</style>

<body>

    <div class="p-1 invoice-preview-height" style="border-style: solid; border-width: 1px;">
    <div> <img
                        style="padding-top: 20px;padding-bottom: 25px; width: 350px;height: 100px;"
                        src="##CompanyLogo##"
                        alt="Company logo"></div>
    
    ##invoicePDFJson## </div>
</body>

</html>',GETDATE(),@UserId,@CompanyId
),
(NEWID(),'SCO Mail',
'<!DOCTYPE html
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

        .button {
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

        .button1 {
            background-color: #4CAF50;
        }

        /* Green */
        .button2 {
            background-color: #eb4034;
        }

        /* Red */
        @@media only screen and (max-device-width: 480px) {

            table[class=hide],
            img[class=hide],
            td[class=hide] {
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
                                                <b>Dear Customer,</b>
                                                </p>
                                                <p style="color:#262626; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif">Thank you for your business!</p>
                                                <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
    Please <a target="_blank" href="##ScoAddress##" style="color: #099">Click
        here</a> to confirm the order details.</p>
                                                
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Warm Regards, <br /> Shobha Exim Team </p>
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

</html>',GETDATE(),@UserId,@CompanyId)
)
AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [TemplateName] = Source.[TemplateName],
           [HtmlTemplate] = Source.[HtmlTemplate],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CompanyId] = Source.[CompanyId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) ;

MERGE INTO [dbo].[HtmlTemplates] AS Target 
USING ( VALUES 

(NEWID(),'SCO Accept/Reject Mail',
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
                                                    ##SCOMESSAGE## 
                                                    <br />
                                                    <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Comments: ##SCOCOMMENTS##</p>
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
</html>',GETDATE(),@UserId,@CompanyId)
)
AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [TemplateName] = Source.[TemplateName],
           [HtmlTemplate] = Source.[HtmlTemplate],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CompanyId] = Source.[CompanyId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) ;

MERGE INTO [dbo].[HtmlTemplates] AS Target 
        USING ( VALUES 
        
        (NEWID(),'Performa Invoice',
        '<!DOCTYPE html>
        <html>
        
        <head>
            <style>
                .invoice-details {
                    border-bottom: 1px solid;
                    border-right: 1px solid;
                }
        
                .performa-table {
                    border: 1px solid;
                    text-align: left;
                    padding: 8px;
                }
        
                .performa-table-option {
                    border-top: 1px solid;
                    border-right: 1px solid;
                    border-bottom: 1px solid;
                    text-align: left;
                }
        
                .performa-table-one {
                    border: 1px solid;
                    text-align: left;
                    vertical-align: top;
                    height: 27.5px;
                }
        
                .sno-border {
                    border-left: 1px solid;
                    border-right: 1px solid;
                    text-align: left;
                    padding: 8px;
                }
        
                .last-row {
                    border-left: 1px solid;
                    border-right: 1px solid;
                    border-bottom: 1px solid;
                    text-align: left;
                    padding: 8px;
                }
        
                .border-right {
                    border-right: 1px solid !important;
                    text-align: left;
                    padding: 8px;
                }
        
                .declaration-border {
                    border-left: 1px solid;
                    border-top: 1px solid;
                    border-bottom: 1px solid;
                }
        
                .padding-8 {
                    padding: 8px;
                }
        
                .border-top-right {
                    border-right: 1px solid;
                    border-top: 1px solid;
                    text-align: left;
                    vertical-align: top;
                    height: 27.5px;
                }
            </style>
        </head>
        
        <body style="font-family: Arial, Helvetica, sans-serif;font-size:10px">
            <div style="border-style: solid; border-width: 1px;flex-direction: column!important;">
                <div style="margin-left: 45px;"> <img
                        style="padding-top: 20px;padding-bottom: 25px; width: 350px;height: 100px;"
                        src="##CompanyLogo##"
                        alt="Company logo">
                    <div style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%; padding-bottom: 40px;">
                        <div style="flex: 1 1 40%;box-sizing: border-box; max-width: 40%;">
                            <div style="border-style: solid; border-width: 1px;height: 75px;padding-left:10px">
                                <div style="padding-top: 10px;"> <b>ShobhaExim</b> </div>
                                <div style="padding-top: 5px;"> GSTIN/UIN: 27AAZCS0690N1ZC </div>
                                <div style="padding-top: 5px;"> State Name : Maharashtra, Code : 27 </div>
                                <div style="padding-top: 5px;padding-bottom: 5px;"> CIN: U74110MH2017PTC298471 </div>
                            </div>
                            <div style="border-bottom: 1px solid;border-right: 1px solid;border-left: 1px solid;padding-left:10px;height:124px">
    <div style="padding-top: 10px;"> Consignee: </div>
    <div style="padding-top: 5px;"> ##AddressLine1## </div>
    <div style="padding-top: 5px;"> ##AddressLine2## </div>
    <div style="padding-top: 5px;"> ##PanNumber## </div>
    <div style="padding-top: 5px;"> ##BusinessEmail## </div>
    <div style="padding-top: 5px;"> ##BusinessNumber## </div>
    <div style="padding-top: 5px;"> ##EximCode## </div>
    <div style="padding-bottom:5px"> </div>
</div>
                        </div>
                        <div style="flex: 1 1 55%;box-sizing: border-box; max-width: 55%;">
                            <table style="width: 100%; border-collapse: collapse;">
                                <tr>
                                    <td class="border-top-right" style="width: 70%;">
                                        <div>Invoice No.</div>
                                        <div>##InvoiceNo##</div>
                                    </td>
                                    <td class="performa-table-one" style="width: 76%;">
                                        <div>Dated</div>
                                        <div>##Date##</div>
                                    </td>
                                </tr> <!-- For loop ends-->
                                <tr>
                                    <td class="border-top-right" style="width: 70%;">
                                        <div>Delivery Note</div>
                                        <div>##DeliveryNote##</div>
                                    </td>
                                    <td class="performa-table-one" style="width: 76%;">
                                        <div>Mode/Terms of Payment:</div>
                                        <div>##PaymentTerms##</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="border-top-right" style="width: 70%;border-bottom: 1px solid">
                                        <div>Suppliers Ref:</div>
                                        <div>##SupllierRef##</div>
                                    </td>
                                    <td class="performa-table-one" style="width: 76%;">
                                        <div>Other Ref:</div>
                                        <div>##OtherRef##</div>
                                    </td>
                                </tr>
                            </table>
                            <table style="width: 55%; border-collapse: collapse;">
                                <tr>
                                    <td style="width: 50%;border-right:1px solid;border-bottom:1px solid">Terms of Delivery :
                                    </td>
                                    <td style="border-right:1px solid">##TermsofDelivery## </td>
                                </tr> <!-- For loop ends-->
                                <tr>
                                    <td class="performa-table-option" style="width: 50%;">Payment Terms:</td>
                                    <td class="performa-table-option">##PaymentTerms## </td>
                                </tr>
                                <tr>
                                    <td class="performa-table-option" style="width: 50%;">Country Of Origin:</td>
                                    <td class="performa-table-option"> ##CountryOfOrigin## </td>
                                </tr>
                                <tr>
                                    <td class="performa-table-option" style="width: 50%;">Shipment:</td>
                                    <td class="performa-table-option"> ##Shipment## </td>
                                </tr>
                                <tr>
                                    <td class="performa-table-option" style="width: 50%;">POD::</td>
                                    <td class="performa-table-option"> ##POD## </td>
                                </tr>
                                <tr>
                                    <td class="performa-table-option" style="width: 40%;">Custom Point:</td>
                                    <td class="performa-table-option"> ##CustomPoint## </td>
                                </tr>
                                <tr>
                                    <td class="performa-table-option" style="width: 40%;">(+/-)5% in amount & Quantity</td>
                                    <td class="performa-table-option"> </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;">
                        <table style="width: 95%; border-collapse: collapse;">
                            <tr>
                                <th class="performa-table" style="width: 9%;">Sr No</th>
                                <th class="performa-table" style="width: 50%;">Description of Goods</th>
                                <th class="performa-table">HSN/SAC</th>
                                <th class="performa-table">Quantity</th>
                                <th class="performa-table">Rate</th>
                                <th class="performa-table">Per</th>
                                <th class="performa-table">Amount</th>
                            </tr> <!-- For loop starts-->
                            <tr>
                                <td class="sno-border"></td>
                                <td class="performa-table">##ProductName## </td>
                                <td class="performa-table">##GstCode## </td>
                                <td class="performa-table">##Quantity## </td>
                                <td class="performa-table">##Rate## </td>
                                <td class="performa-table">MT </td>
                                <td class="performa-table">##TotalAmount## </td>
                            </tr>
                            <tr>
                                <td class="sno-border"></td>
                                <td class="padding-8">Output IGST @18%-M </td>
                                <td class="padding-8"> </td>
                                <td class="padding-8"> </td>
                                <td class="padding-8"> </td>
                                <td class="padding-8">18% </td>
                                <td class="padding-8" style="border-right: 1px solid;"> </td>
                            </tr>
                            <tr>
                                <td class="sno-border"></td>
                                <td class="padding-8">Output CGST @9%-M </td>
                                <td class="padding-8"> </td>
                                <td class="padding-8"> </td>
                                <td class="padding-8"> </td>
                                <td class="padding-8">9% </td>
                                <td class="padding-8" style="border-right: 1px solid;"> </td>
                            </tr>
                            <tr>
                                <td class="sno-border"></td>
                                <td class="padding-8">Output SGST @9%-M </td>
                                <td class="padding-8"> </td>
                                <td class="padding-8"> </td>
                                <td class="padding-8"> </td>
                                <td class="padding-8">9% </td>
                                <td class="padding-8" style="border-right: 1px solid;"> </td>
                            </tr> <!-- For loop ends-->
                            <tr>
                                <td class="performa-table"></td>
                                <td class="performa-table">##LoadingFrom##</td>
                                <td class="performa-table"> </td>
                                <td class="performa-table">##Quantity## </td>
                                <td class="performa-table"> </td>
                                <td class="performa-table">INR </td>
                                <td class="performa-table">##TotalAmount## </td>
                            </tr>
                        </table>
                        <table style="width: 95%; border-collapse: collapse;">
                            <tr class="last-row">
                                <td style="padding: 8px;text-align: left;width: 90%;">Amount chargable (in words)</td>
                                <td>E. & O.E</td>
                            </tr>
                        </table>
                    </div>
                    <div
                        style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;padding-bottom: 10px;padding-top:10px">
                        ##TotalAmountInWords## </div>
                    <div style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;">
                        <table style="width: 95%; border-collapse: collapse;font-size:10px" class="performa-table">
                            <col>
                            <colgroup span="2"></colgroup>
                            <colgroup span="2"></colgroup>
                            <tr>
                                <th rowspan="2" style="width:16%">HSN/SAC</th>
                                <th class="performa-table" style="width:1%">Taxable</th>
                                <th colspan="2" scope="colgroup" class="performa-table" style="width:1%">Integrated Tax</th>
                                <th colspan="2" scope="colgroup" class="performa-table" style="width:1%">Central Tax</th>
                                <th colspan="2" scope="colgroup" class="performa-table" style="width:1%">State Tax</th>
                                <th class="performa-table" style="width:11%">Taxable</th>
                            </tr>
                            <tr class="performa-table">
                                <th class="performa-table">Value</th>
                                <th scope="col" class="border-right">Rate</th>
                                <th scope="col" class="border-right">Amount</th>
                                <th scope="col" class="border-right">Rate</th>
                                <th scope="col" class="border-right">Amount</th>
                                <th scope="col" class="border-right">Rate</th>
                                <th scope="col" class="border-right">Amount</th>
                                <th scope="col" class="border-right">Tax Amount</th>
                            </tr>
                            <tr class="performa-table">
                                <td>##ProductName##</td>
                                <td class="performa-table">##TotalAmount##</td>
                                <td class="border-right">18</td>
                                <td class="border-right">0</td>
                                <td class="border-right">18</td>
                                <td class="border-right">0</td>
                                <td class="border-right">9</td>
                                <td class="border-right">0</td>
                                <td class="border-right"></td>
                            </tr>
                            <tr class="performa-table">
                                <td>Total</td>
                                <td class="performa-table">##TotalAmount##</td>
                                <td class="border-right">18</td>
                                <td class="border-right">0</td>
                                <td class="border-right">18</td>
                                <td class="border-right">0</td>
                                <td class="border-right">9</td>
                                <td class="border-right">0</td>
                                <td class="border-right"></td>
                            </tr>
                        </table>
                    </div>
                    <div
                        style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;padding-bottom: 20px;padding-top:10px">
                        Total Tax Amount in Words:  </div>
                    <div style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;padding-bottom: 30px;">
                        <div style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;">
                            <div style="flex: 1 1 50%;box-sizing: border-box; max-width: 50%;"> Companys PAN : ##CompanyPan##
                            </div>
                            <div style="flex: 1 1 50%;box-sizing: border-box; max-width: 50%;">
                                <div style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;">
                                    <div style="flex: 1 1 50%;box-sizing: border-box; max-width: 50%;"> Companys Bank Details
                                    </div>
                                    <div style="flex: 1 1 50%;box-sizing: border-box; max-width: 50%;"> </div>
                                </div>
                                <div style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;">
                                    <div style="flex: 1 1 25%;box-sizing: border-box; max-width: 25%;"> Bank Name.: </div>
                                    <div style="flex: 1 1 50%;box-sizing: border-box; max-width: 50%;"> ##BankName## </div>
                                </div>
                                <div style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;">
                                    <div style="flex: 1 1 25%;box-sizing: border-box; max-width: 25%;"> A/c No </div>
                                    <div style="flex: 1 1 50%;box-sizing: border-box; max-width: 50%;"> ##ACNO## </div>
                                </div>
                                <div style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;">
                                    <div style="flex: 1 1 25%;box-sizing: border-box; max-width: 25%;"> Branch & IFS Code:
                                    </div>
                                    <div style="flex: 1 1 50%;box-sizing: border-box; max-width: 50%;"> ##Branch&IFSCode##
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div style="flex: 1 1 87%;box-sizing: border-box;max-width: 87%;margin-left: 30px;">
                        <div style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;">
                            <div class="declaration-border"
                                style="flex: 1 1 60%;box-sizing: border-box; max-width: 60%;padding: 8px;"> I/We hereby certify
                                that my/our registration certificate under the Goods and Service Tax act,2017 is in force on the
                                date on which the sale of the goods specified in this Tax Invoice is made by me/us and that the
                                transaction of sale covered by this Tax Invoice has been effected by me/us and it shall be
                                accounted for in the turnover of effected by me/us and it shall be accounted for in the turnover
                                of sale has been paid or shall be paid. </div>
                            <div class="declaration-border"
                                style="border-right: 1px solid;flex: 1 1 40%;box-sizing: border-box; max-width: 40%;"> </div>
                        </div>
                    </div>
                    <div style="margin-left: 200px;padding-top:10px"> SUBJECT TO MUMBAI JURISDICTION </div>
                    <div style="margin-left: 200px;padding-bottom:10px"> This is a Computer Generated Invoice </div>
                    <div style="flex: 1 1 87%;box-sizing: border-box;max-width: 87%;margin-left: 30px;">
                        <div
                            style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;padding-bottom: 21px;">
                            <div style="padding: 8px;flex: 1 1 60%;box-sizing: border-box; max-width: 60%;">
                                <div> 2408, 24th Floor, Haware Infotech Park, </div>
                                <div> Sector 30A, Near Vashi Railway Station, </div>
                                <div> Vashi, Navi Mumbai - 400 703. INDIA </div>
                            </div>
                            <div style="flex: 1 1 40%;box-sizing: border-box; max-width: 40%;">
                                <div style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;">
                                    <div style="flex: 1 1 25%;box-sizing: border-box; max-width: 25%;"> Phone: </div>
                                    <div style="flex: 1 1 50%;box-sizing: border-box; max-width: 50%;"> + 91-22-2087 2090 </div>
                                </div>
                                <div style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;">
                                    <div style="flex: 1 1 25%;box-sizing: border-box; max-width: 25%;"> Email: </div>
                                    <div style="flex: 1 1 50%;box-sizing: border-box; max-width: 50%;"> info@shobhaexim.com
                                    </div>
                                </div>
                                <div style="flex-flow: row wrap;box-sizing: border-box;display: flex;flex: 1 1 0%;">
                                    <div style="flex: 1 1 25%;box-sizing: border-box; max-width: 25%;"> CIN </div>
                                    <div style="flex: 1 1 50%;box-sizing: border-box; max-width: 50%;"> U74110MH2017PTC298471
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>
        
        </html>',GETDATE(),@UserId,@CompanyId
))
AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [TemplateName] = Source.[TemplateName],
           [HtmlTemplate] = Source.[HtmlTemplate],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CompanyId] = Source.[CompanyId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) ;

MERGE INTO [dbo].[HtmlTemplates] AS Target 
USING ( VALUES 

(NEWID(),'WH Mail Template',
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
                
                .button {
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

				.button1 {background-color: #4CAF50;} /* Green */
				.button2 {background-color: #eb4034;} /* Red */
        
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
                                                    <b>Dear Warehouse Team,</b>
                                                </p>
                                                <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
Please complete the steps for the order fulfilment from our warehouse and
        <a target="_blank" href="##ScoAddress##" style="color: #099">Click
            here</a> to update final details in the form.<br /> </p>

                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Thank you! <br />
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
</html>',GETDATE(),@UserId,@CompanyId)
)
AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [TemplateName] = Source.[TemplateName],
           [HtmlTemplate] = Source.[HtmlTemplate],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CompanyId] = Source.[CompanyId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) ;

MERGE INTO [dbo].[HtmlTemplates] AS Target 
USING ( VALUES 

(NEWID(),'PurchaseShipmentCHATemplate',
'<!DOCTYPE html
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

        .button {
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

        .button1 {
            background-color: #4CAF50;
        }

        /* Green */
        .button2 {
            background-color: #eb4034;
        }

        /* Red */
        @@media only screen and (max-device-width: 480px) {

            table[class=hide],
            img[class=hide],
            td[class=hide] {
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
                                                <b>Hello,</b>
                                                </p>
                                                <p style="color:#262626; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif">Please find the details of the BL <b>##BLNumber##</b></p>
                                                <p style="color:#262626; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif">Kindly share the draft Bill of Entry for our review.</p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Thank you<br />
                                                    Warm Regards, <br /> ##footerName## </p>
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

</html>',GETDATE(),@UserId,@CompanyId),
(NEWID(),'PurchaseShipmentCHAPDFTemplate','<table style="width: 100%; border-collapse: collapse;"><tr>
<th class="form-v-table"style="background-color:#cececa">Fields</th><th class="form-v-table"style="background-color:#cececa">Value</th></tr>
<tr>
<td class="form-v-table">Shipment Number</td>
<td class="form-v-table">##ShipmentNumber##</td>
</tr>
<tr>
<td class="form-v-table">Vessel Name</td>
<td class="form-v-table">##VesselName##</td>
</tr>
<tr>
<td class="form-v-table">Voyage Number</td>
<td class="form-v-table">##VoyageNumber##</td>
</tr>
<tr>
<td class="form-v-table">BL Number</td>
<td class="form-v-table">##BLNumber##</td>
</tr>
<tr>
<td class="form-v-table">BL Date</td>
<td class="form-v-table">##BLDate##</td>
</tr>
<tr>
<td class="form-v-table">BL QTY</td>
<td class="form-v-table">##BLQty##</td>
</tr>
<tr>
<td class="form-v-table">BL Price</td>
<td class="form-v-table">##BLPrice##</td>
</tr>
<tr>
<td class="form-v-table">BL Value</td>
<td class="form-v-table">##BLValue##</td>
</tr>
<tr>
<td class="form-v-table">Product</td>
<td class="form-v-table">##Product##</td>
</tr>
<tr>
<td class="form-v-table">Grade</td>
<td class="form-v-table">##Grade##</td>
</tr>
<tr>
<td class="form-v-table">Vessel ETA</td>
<td class="form-v-table">##VesselETA##</td>
</tr>
<tr>
<td class="form-v-table">Loading port</td>
<td class="form-v-table">##LoadingPort##</td>
</tr>
<tr>
<td class="form-v-table">Discharge Port</td>
<td class="form-v-table">##DischargePort##</td>
</tr>
</table>',GETDATE(),@UserId,@CompanyId)
)
AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [TemplateName] = Source.[TemplateName],
           [HtmlTemplate] = Source.[HtmlTemplate],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CompanyId] = Source.[CompanyId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) ;

MERGE INTO [dbo].[HtmlTemplates] AS Target 
USING ( VALUES 

(NEWID(),'Duty Employee Template',
'<!DOCTYPE html
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

        .button {
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

        .button1 {
            background-color: #4CAF50;
        }

        /* Green */
        .button2 {
            background-color: #eb4034;
        }

        /* Red */
        @@media only screen and (max-device-width: 480px) {

            table[class=hide],
            img[class=hide],
            td[class=hide] {
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
                                                <b>Dear Employee,</b>
                                                </p>
                                                <p style="color:#262626; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif">You have assigned as duty employee for BOE ##ShipmentNumber##</p>
                                                <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
    Please <a target="_blank" href="##PurchaseExecutionUrl##" style="color: #099">Click
        here</a> for further procress.</p>
                                                
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Warm Regards, <br /> ##footerName## </p>
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

</html>',GETDATE(),@UserId,@CompanyId)
)
AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [TemplateName] = Source.[TemplateName],
           [HtmlTemplate] = Source.[HtmlTemplate],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CompanyId] = Source.[CompanyId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) ;

MERGE INTO [dbo].[HtmlTemplates] AS Target 
USING ( VALUES 

(NEWID(),'CHAConfirmationTemplate',
'<!DOCTYPE html
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

        .button {
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

        .button1 {
            background-color: #4CAF50;
        }

        /* Green */
        .button2 {
            background-color: #eb4034;
        }

        /* Red */
        @@media only screen and (max-device-width: 480px) {

            table[class=hide],
            img[class=hide],
            td[class=hide] {
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
                                                <b>Hello,</b>
                                                </p>
                                                <p style="color:#262626; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif">Please treat this as confirmation to the draft Bill of Entry that you have sent across for the BL number <b>##BLNumber##</b></p>
                                                <p style="color:#262626; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif">Kindly prepare the final bill of entry and share with us.</p>
                                                <p style="color:#262626; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif">Thank you</p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Warm Regards, <br /> ##footerName## </p>
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

</html>',GETDATE(),@UserId,@CompanyId)
)
AS Source ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [TemplateName] = Source.[TemplateName],
           [HtmlTemplate] = Source.[HtmlTemplate],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CompanyId] = Source.[CompanyId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) VALUES ([Id], [TemplateName], [HtmlTemplate], [CreatedDateTime], [CreatedByUserId], [CompanyId]) ;

END