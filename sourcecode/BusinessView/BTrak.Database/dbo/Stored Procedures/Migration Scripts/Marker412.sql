CREATE PROCEDURE [dbo].[Marker412]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
    
   DECLARE @Currentdate DATETIME = GETDATE()

    DECLARE @Template TABLE
	(
		EmailTemplateName NVARCHAR(250)
		,[EmailTemplate] NVARCHAR(MAX)
		,[EmailSubject] NVARCHAR(2000)
        ,[EmailTemplateReferenceId] UNIQUEIDENTIFIER
	)

	INSERT INTO @Template(EmailTemplateName,EmailTemplate,EmailSubject,EmailTemplateReferenceId)
	VALUES
	

  ('FreightCertificatePdfTemplate','<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MGV COMMODITY PTE LTD</title>
    <style>
        body{
            background-color: #F6F6F6; 
            margin: 0;
            padding: 0;
            font-family: Verdana, Geneva, sans-serif;
            font-style: normal; font-variant: normal;
        }
        h1,h2,h3,h4,h5,h6{
            margin: 0;
            padding: 0;
        }
        p{
            margin: 0;
            padding: 0;
        }
        .container{
            width: 80%;
            margin-right: auto;
            margin-left: auto;
        }
        .row{
            display: flex;
            flex-wrap: wrap;
        }
        .col-6{
            width: 50%;
            flex: 0 0 auto;
        }
        .col-4{
            width: 25%;
            flex: 0 0 auto;
        }
        .col-8{
            width: 74%;
            flex: 0 0 auto;
        }
        .col-12{
            width: 100%;
            flex: 0 0 auto;
        }
        .body-section{
            padding: 80px;
            /*border: 1px solid gray;*/
        }
        .sub-heading{
            color: #262626;
            margin-bottom: 05px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="body-section">
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading" style="text-align: center; color: red; font-size: 40px;">MGV COMMODITY PTE LTD</p>
                    <p class="sub-heading" style="text-align: center; font-weight: 600;">77 HIGH STREET #4-11 HIGH STREET PLAZA, SINGAPORE 179433</p>
                    <p class="sub-heading" style="text-align: center;">Registration No. 201618435E PHONE +65-63362665</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 30px;">
                    <p class="sub-heading" style="font-weight: 600;">DATE : ##CurrentDate#</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 30px;">
                    <p class="sub-heading" style="font-weight: 600; text-decoration: underline; text-align: center;">FREIGHT CERTIFICATE</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 30px;">
                    <p class="sub-heading" style="font-weight: 600; text-decoration: underline;">TO WHOM IT MAY CONCERN</p>
                </div>
            </div>    
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <table>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">VESSEL</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##VesselName##</td>
                        </tr>
                         <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">GOODS</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##CommodityName##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">PORT OF LOADING</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##CountryName##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">PORT OF DISCHARGE</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##PortOfDischarge##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">BILL OD LANDING OF DATE<br><br></td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##BillOfLanding##
                                <br><span style="margin-left: 10px;">##BillOfLanding##</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">QUANTITY IN MTS</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##QuantityUnits##</td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 30px;">
                    <p class="sub-heading" style="font-weight: 600;">===========================================================</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <p class="sub-heading" style="font-weight: 600;">WE HERE BY CERTIFY THAT FREIGHT ON THIS SHIPMENT IS USD 50 USD ON FIXED QTY OF #10,000#</p>
                    <p class="sub-heading" style="font-weight: 600;">MT FRIEGHT AMOUNT PAID WAS USD ##freightInWords## ONLY</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 70px;">
                    <p class="sub-heading" style="font-weight: 600; font-size: 20px;">MGV COMMODITIY PTE LTD</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 70px;">
                    <p class="sub-heading" style="font-weight: 600; font-size: 20px;">AUTHORISED SIGNATORY</p>
                </div>
            </div>  
        </div>    
    </div>      
</body>
</html>','Freight Certificate',N'9FD1866A-9938-446B-BEDE-772FF45C7AD4')

,('ShelfLifeCertificatePdfTemplate','<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MGV COMMODITY PTE LTD</title>
    <style>
        body{
            background-color: #F6F6F6; 
            margin: 0;
            padding: 0;
            font-family: Verdana, Geneva, sans-serif;
            font-style: normal; font-variant: normal;
        }
        h1,h2,h3,h4,h5,h6{
            margin: 0;
            padding: 0;
        }
        p{
            margin: 0;
            padding: 0;
        }
        .container{
            width: 80%;
            margin-right: auto;
            margin-left: auto;
        }
        .row{
            display: flex;
            flex-wrap: wrap;
        }
        .col-6{
            width: 50%;
            flex: 0 0 auto;
        }
        .col-4{
            width: 25%;
            flex: 0 0 auto;
        }
        .col-8{
            width: 74%;
            flex: 0 0 auto;
        }
        .col-12{
            width: 100%;
            flex: 0 0 auto;
        }
        .body-section{
            padding: 80px;
            /*border: 1px solid gray;*/
        }
        .sub-heading{
            color: #262626;
            margin-bottom: 05px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="body-section">
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading" style="text-align: center; color: red; font-size: 40px;">MGV COMMODITY PTE LTD</p>
                    <p class="sub-heading" style="text-align: center; font-weight: 600;">77 HIGH STREET #4-11 HIGH STREET PLAZA, SINGAPORE 179433</p>
                    <p class="sub-heading" style="text-align: center;">Registration No. 201618435E PHONE +65-63362665</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 30px;">
                    <p class="sub-heading" style="font-weight: 600;">DATE : #22/04/2022#</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 30px;">
                    <p class="sub-heading" style="font-weight: 600; text-decoration: underline; text-align: center;">SHELF LIFE CERTIFICATE</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 30px;">
                    <p class="sub-heading" style="font-weight: 600; text-decoration: underline;">TO WHOM IT MAY CONCERN</p>
                </div>
            </div>    
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <table>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">VESSEL</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##VesselName##</td>
                        </tr>
                         <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">GOODS</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##CommodityName##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">PORT OF LOADING</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##CountryName##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">PORT OF DISCHARGE</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##PortOfDischarge##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">BILL OD LANDING OF DATE<br><br></td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##BillOfLanding##
                                <br><span style="margin-left: 10px;">##BillOfLanding##</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">QUANTITY IN MTS</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##QuantityUnits##</td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 30px;">
                    <p class="sub-heading" style="font-weight: 600;">===========================================================</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <p class="sub-heading" style="font-weight: 600;">WE HERE BY CERTIFY THAT SHELF LIFE OF THIS CONSIGNMENT OF CRUDE PALM OIL</p>
                    <p class="sub-heading" style="font-weight: 600;">(EDIBLE GRADE) IN BULK IS OF ONE YEAR AS FOLLOWS: </p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <table>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">DATE OF MANUFATURE</td>
                            <td style="padding-bottom: 10px; font-weight: 600; padding-left: 40px;">: ##ManufactureDate##</td>
                        </tr>
                         <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">DATE OF EXPIRY</td>
                            <td style="padding-bottom: 10px; font-weight: 600; padding-left: 40px;">: ##ExpiryDate##</td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 70px;">
                    <p class="sub-heading" style="font-weight: 600; font-size: 20px;">MGV COMMODITIY PTE LTD</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 70px;">
                    <p class="sub-heading" style="font-weight: 600; font-size: 20px;">AUTHORISED SIGNATORY</p>
                </div>
            </div>  
        </div>    
    </div>      
</body>
</html>','Shelf Life Certificate ',N'C6E1B4C1-A5BC-4D2A-944C-E901B70B80F7')

,('CertificateOfOriginPdfTemplate','<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MGV COMMODITY PTE LTD</title>
    <style>
        body{
            background-color: #F6F6F6; 
            margin: 0;
            padding: 0;
            font-family: Verdana, Geneva, sans-serif;
            font-style: normal; font-variant: normal;
        }
        h1,h2,h3,h4,h5,h6{
            margin: 0;
            padding: 0;
        }
        p{
            margin: 0;
            padding: 0;
        }
        .container{
            width: 80%;
            margin-right: auto;
            margin-left: auto;
        }
        .row{
            display: flex;
            flex-wrap: wrap;
        }
        .col-6{
            width: 50%;
            flex: 0 0 auto;
        }
        .col-4{
            width: 25%;
            flex: 0 0 auto;
        }
        .col-8{
            width: 74%;
            flex: 0 0 auto;
        }
        .col-12{
            width: 100%;
            flex: 0 0 auto;
        }
        .body-section{
            padding: 80px;
            /*border: 1px solid gray;*/
        }
        .sub-heading{
            color: #262626;
            margin-bottom: 05px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="body-section">
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading" style="text-align: center; color: red; font-size: 40px;">MGV COMMODITY PTE LTD</p>
                    <p class="sub-heading" style="text-align: center; font-weight: 600;">77 HIGH STREET #4-11 HIGH STREET PLAZA, SINGAPORE 179433</p>
                    <p class="sub-heading" style="text-align: center;">Registration No. 201618435E PHONE +65-63362665</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 30px;">
                    <p class="sub-heading" style="font-weight: 600;">DATE : ##CurrentDate##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 30px;">
                    <p class="sub-heading" style="font-weight: 600; text-decoration: underline; text-align: center;">CERTIFICATE OF ORIGIN</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 30px;">
                    <p class="sub-heading" style="font-weight: 600; text-decoration: underline;">TO WHOM IT MAY CONCERN</p>
                </div>
            </div>    
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <table>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">VESSEL</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##VesselName##</td>
                        </tr>
                         <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">GOODS</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##CommodityName##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">PORT OF LOADING</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##CountryName##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">PORT OF DISCHARGE</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: #PortOfDischarge#</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">BILL OD LANDING OF DATE<br><br></td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##BillOfLanding##
                                <br><span style="margin-left: 10px;">##BillOfLanding##</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 10px; font-weight: 600;">QUANTITY IN MTS</td>
                            <td style="padding-bottom: 10px; font-weight: 600;">: ##QuantityUnits##</td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 30px;">
                    <p class="sub-heading" style="font-weight: 600;">===========================================================</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <p class="sub-heading" style="font-weight: 600;">WE HERE BY CERTIFY THAT THIS CONSIGNMENT OF GRADE PALMKERNEL OLI (EDIBLE GRADE) IN</p>
                    <p class="sub-heading" style="font-weight: 600;">BULKS IS OF PAPUA NEW GUINEA ORIGIN.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 70px;">
                    <p class="sub-heading" style="font-weight: 600; font-size: 20px;">MGV COMMODITIY PTE LTD</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 70px;">
                    <p class="sub-heading" style="font-weight: 600; font-size: 20px;">AUTHORISED SIGNATORY</p>
                </div>
            </div>  
        </div>    
    </div>      
</body>
</html>','Certificate of Origin Certificate ',N'7E33FF11-BE4C-41DF-BE28-0D1295B14AC3'),
('InvoiceToBuyerStepEmailTemplate','<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>MGV COMMODITY PTE LTD</title><style>body{background-color:#f6f6f6;margin:0;padding:0;font-family:Verdana,Geneva,sans-serif;font-style:normal;font-variant:normal}h1,h2,h3,h4,h5,h6{margin:0;padding:0}p{margin:0;padding:0}.container{width:80%;margin-right:auto;margin-left:auto}.row{display:flex;flex-wrap:wrap}.col-6{width:50%;flex:0 0 auto}.col-4{width:30%;flex:0 0 auto}.col-3{width:23%;flex:0 0 auto}.col-8{width:74%;flex:0 0 auto}.col-12{width:100%;flex:0 0 auto}.body-section{padding:80px}.sub-heading{color:#262626}</style></head><body><div class="container"><div class="body-section"><div class="row"><div class="col-12"><p class="sub-heading" style="text-align:center;color:red;font-size:40px">MGV COMMODITY PTE LTD</p><p class="sub-heading" style="text-align:center;font-weight:600">77 HIGH STREET #4-11 HIGH STREET PLAZA, SINGAPORE 179433</p><p class="sub-heading" style="text-align:center">Registration No. 201618435E PHONE +65-63362665</p></div></div><div class="row"><div class="col-12" style="margin-top:20px"><p class="sub-heading" style="font-weight:600;text-decoration:underline;text-align:center;font-size:16px">COMMERCIAL INVOICE</p></div></div><div class="row"><div class="col-6" style="margin-top:10px"><p class="sub-heading" style="font-weight:600;font-size:14px">No : ##InvoiceNumber##</p></div><div class="col-6" style="margin-top:10px"><p class="sub-heading" style="font-weight:600;float:right;font-size:14px">Date : ##IssueDate##</p></div></div><div class="row"><div class="col-12" style="margin-top:5px"><p class="sub-heading" style="font-weight:600;font-size:14px">BUYER:</p></div></div><div class="row"><div class="col-12" style="margin-top:5px"><p class="sub-heading" style="font-weight:600;font-size:14px">##BuyerName##</p><p class="sub-heading" style="font-weight:600;font-size:14px">##BuyerAddressLine1##</p><p class="sub-heading" style="font-weight:600;font-size:14px">##BuyerAddressLine2##</p></div></div><div class="row"><div class="col-12"><hr style="background:#000"></div></div><div class="row"><div class="col-12"><table><tr><td style="padding-bottom:10px;font-size:14px">PORT OF LOADING</td><td style="padding-bottom:10px;font-size:14px">: ##PortLoad##</td></tr><tr><td style="padding-bottom:10px;font-size:14px">PORT OF DISCHARGE</td><td style="padding-bottom:10px;font-size:14px">: ##PortDischarge##</td></tr><tr><td style="padding-bottom:10px;font-size:14px">B/L NO. & DATE<br><br></td><td style="padding-bottom:10px;font-size:14px">: ##BLNoAndDate##</td></tr><tr><td style="padding-bottom:10px;font-size:14px">NAME OF VESSEL</td><td style="padding-bottom:10px;font-size:14px">: ##VesselName##</td></tr><tr><td style="padding-bottom:10px;font-size:14px">PAYMENT TERMS</td><td style="padding-bottom:10px;font-size:14px">: ##PaymentTerms##</td></tr><tr><td style="padding-bottom:10px;font-size:14px">DRAWEE''S BANK</td><td style="padding-bottom:10px;font-size:14px">: ##DraweesBank##</td></tr></table></div></div><div class="row"><div class="col-12"><hr style="background:#000"></div></div><div class="row"><div class="col-4" style="font-size:14px;text-align:center;font-weight:600"><p class="sub-heading">DESCRIPTION OF GOODS</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading">QUANTITY MT</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading">UNIT PRICE (USD)<br>CFR HALDIA, INDIA</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading">AMOUNT (USD)</p></div></div><div class="row"><div class="col-12"><hr style="background:#000"></div></div><div class="row"><div class="col-4" style="font-size:14px;font-weight:600"><p class="sub-heading">CRUDE PALM OIL (EDIBLE GRADE) IN BULK</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading">##Quantity##</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading">##UnitPrice##</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading">##Amount##</p></div></div></div><div class="row" style="margin-top:20px"><div class="col-4" style="font-size:14px;font-weight:600"><p class="sub-heading" style="text-align:center">TOTAL QTY</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading" style="border-top-style:dotted;border-bottom-style:dotted;padding:10px">##Quantity##</p></div><div class="col-3" style="font-size:14px;font-weight:600"></div><div class="col-3" style="font-size:14px;font-weight:600"></div></div><div class="row" style="margin-top:20px"><div class="col-4"><p class="sub-heading" style="font-weight:600;font-size:13px">WE CERTIFY:</p><p class="sub-heading" style="font-size:12px">A) THAT IMPORT IS NOT UNDER NEGATIVE LIST AND FREELY IMPORTABLE AS PER INDIA''S FOREGIN TRADE POLICY 2022</p><p class="sub-heading" style="font-size:12px;margin-top:10px">B) THAT THE OIL IS FREE FROM CONMTAMINATION AND SEA WATER AT THE TIME OF SHIPMENT AND THIS CONSIGNMENT DOES NOT CONTAIN BEEF IN ANY FORM</p><p class="sub-heading" style="font-size:12px;margin-top:10px">C) THAT THE FREIGHT CHARGED FOR THIS SHIPMENT IS USD 50 PER MT</p><p class="sub-heading" style="font-size:12px;margin-top:10px">D) THE GOODS ARE OF PAPUA NEW GUINEA ORIGIN</p><p class="sub-heading" style="font-size:12px;margin-top:10px;font-weight:600">QUALITY SPECIFICATION</p><p class="sub-heading" style="font-size:12px;margin-top:10px;text-decoration:underline;font-weight:600">TERMS</p><p class="sub-heading" style="font-size:12px;margin-top:10px">FFA 4.5% MAX</p><p class="sub-heading" style="font-size:12px;margin-top:10px">MN 0.5% MAX</p></div><div class="col-3" style="font-size:14px;font-weight:600"></div><div class="col-3" style="font-size:14px;font-weight:600"></div><div class="col-3" style="font-size:14px;font-weight:600"></div></div><div class="row" style="margin-top:20px"><div class="col-4" style="font-size:14px;font-weight:600"><p class="sub-heading">TOTAL INVOICE VALUE US$</p></div><div class="col-3" style="font-size:14px;font-weight:600"></div><div class="col-3" style="font-size:14px;font-weight:600"></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading" style="border-top-style:dotted;border-bottom-style:dotted;padding:10px">##Amount##</p></div></div><div class="row"><div class="col-12" style="margin-top:10px"><p class="sub-heading" style="font-weight:600;font-size:12px">(US DOLLARS ELEVEN MILLION TWENTY SEVEN THOUSAND SIX HUNDERED SEVENTY AND CENT SIXTY THREE ONLY)</p><hr style="background:#000"><p class="sub-heading" style="font-size:12px;font-weight:600">Payment by Telegraphic Transfer to our account as under:</p></div></div><div class="row"><div class="col-12"><table><tr><td style="padding-bottom:10px;font-size:14px">Bank Name</td><td style="padding-bottom:10px;font-size:14px">: HSBC LIMITED, 9 Battery Road #12-01 MYP Centre, SINGAPORE 049910</td></tr><tr><td style="padding-bottom:10px;font-size:14px">Swift Code</td><td style="padding-bottom:10px;font-size:14px">: HSBCSGSG</td></tr><tr><td style="padding-bottom:10px;font-size:14px">Branch Code</td><td style="padding-bottom:10px;font-size:14px">: 7232</td></tr><tr><td style="padding-bottom:10px;font-size:14px">Account Name</td><td style="padding-bottom:10px;font-size:14px">: MGV COMMODITY PTE LTD</td></tr><tr><td style="padding-bottom:10px;font-size:14px">Accont Number(USD)</td><td style="padding-bottom:10px;font-size:14px;font-weight:600">: 25637373889</td></tr></table></div></div><div class="row"><div class="col-12" style="margin-top:10px"><p class="sub-heading" style="font-weight:600;font-style:italic">Please Quote Invoice number in the description filed of the remittance</p><hr style="background:#000"></div></div><div class="row"><div class="col-12"><p class="sub-heading" style="font-weight:600;font-size:16px">MGV COMMODITIY PTE LTD</p></div></div><div class="row"><div class="col-12" style="margin-top:70px"><p class="sub-heading" style="font-weight:600;font-size:14px">AUTHORISED SIGNATORY</p></div></div></div></body></html>',
  'Invoice To Buyer',N'B221C937-CE8C-4146-8498-9CB9CA579140'),
  ('InvoiceFromSellerStepEmailTemplate','<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>MGV COMMODITY PTE LTD</title><style>body{background-color:#f6f6f6;margin:0;padding:0;font-family:Verdana,Geneva,sans-serif;font-style:normal;font-variant:normal}h1,h2,h3,h4,h5,h6{margin:0;padding:0}p{margin:0;padding:0}.container{width:80%;margin-right:auto;margin-left:auto}.row{display:flex;flex-wrap:wrap}.col-6{width:50%;flex:0 0 auto}.col-4{width:30%;flex:0 0 auto}.col-3{width:23%;flex:0 0 auto}.col-8{width:74%;flex:0 0 auto}.col-12{width:100%;flex:0 0 auto}.body-section{padding:80px}.sub-heading{color:#262626}</style></head><body><div class="container"><div class="body-section"><div class="row"><div class="col-12"><p class="sub-heading" style="text-align:center;color:red;font-size:40px">MGV COMMODITY PTE LTD</p><p class="sub-heading" style="text-align:center;font-weight:600">77 HIGH STREET #4-11 HIGH STREET PLAZA, SINGAPORE 179433</p><p class="sub-heading" style="text-align:center">Registration No. 201618435E PHONE +65-63362665</p></div></div><div class="row"><div class="col-12" style="margin-top:20px"><p class="sub-heading" style="font-weight:600;text-decoration:underline;text-align:center;font-size:16px">COMMERCIAL INVOICE</p></div></div><div class="row"><div class="col-6" style="margin-top:10px"><p class="sub-heading" style="font-weight:600;font-size:14px">No : ##InvoiceNumber##</p></div><div class="col-6" style="margin-top:10px"><p class="sub-heading" style="font-weight:600;float:right;font-size:14px">Date : ##IssueDate##</p></div></div><div class="row"><div class="col-12" style="margin-top:5px"><p class="sub-heading" style="font-weight:600;font-size:14px">BUYER:</p></div></div><div class="row"><div class="col-12" style="margin-top:5px"><p class="sub-heading" style="font-weight:600;font-size:14px">##SellerName##</p><p class="sub-heading" style="font-weight:600;font-size:14px">##SellerAddressLine1##</p><p class="sub-heading" style="font-weight:600;font-size:14px">##SellerAddressLine2##</p></div></div><div class="row"><div class="col-12"><hr style="background:#000"></div></div><div class="row"><div class="col-12"><table><tr><td style="padding-bottom:10px;font-size:14px">PORT OF LOADING</td><td style="padding-bottom:10px;font-size:14px">: ##PortLoad##</td></tr><tr><td style="padding-bottom:10px;font-size:14px">PORT OF DISCHARGE</td><td style="padding-bottom:10px;font-size:14px">: ##PortDischarge##</td></tr><tr><td style="padding-bottom:10px;font-size:14px">B/L NO. & DATE<br><br></td><td style="padding-bottom:10px;font-size:14px">: ##BLNoAndDate##</td></tr><tr><td style="padding-bottom:10px;font-size:14px">NAME OF VESSEL</td><td style="padding-bottom:10px;font-size:14px">: ##VesselName##</td></tr><tr><td style="padding-bottom:10px;font-size:14px">PAYMENT TERMS</td><td style="padding-bottom:10px;font-size:14px">: ##PaymentTerms##</td></tr><tr><td style="padding-bottom:10px;font-size:14px">DRAWEE''S BANK</td><td style="padding-bottom:10px;font-size:14px">: ##DraweesBank##</td></tr></table></div></div><div class="row"><div class="col-12"><hr style="background:#000"></div></div><div class="row"><div class="col-4" style="font-size:14px;text-align:center;font-weight:600"><p class="sub-heading">DESCRIPTION OF GOODS</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading">QUANTITY MT</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading">UNIT PRICE (USD)<br>CFR HALDIA, INDIA</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading">AMOUNT (USD)</p></div></div><div class="row"><div class="col-12"><hr style="background:#000"></div></div><div class="row"><div class="col-4" style="font-size:14px;font-weight:600"><p class="sub-heading">CRUDE PALM OIL (EDIBLE GRADE) IN BULK</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading">##Quantity##</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading">##UnitPrice##</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading">##Amount##</p></div></div></div><div class="row" style="margin-top:20px"><div class="col-4" style="font-size:14px;font-weight:600"><p class="sub-heading" style="text-align:center">TOTAL QTY</p></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading" style="border-top-style:dotted;border-bottom-style:dotted;padding:10px">##Quantity##</p></div><div class="col-3" style="font-size:14px;font-weight:600"></div><div class="col-3" style="font-size:14px;font-weight:600"></div></div><div class="row" style="margin-top:20px"><div class="col-4"><p class="sub-heading" style="font-weight:600;font-size:13px">WE CERTIFY:</p><p class="sub-heading" style="font-size:12px">A) THAT IMPORT IS NOT UNDER NEGATIVE LIST AND FREELY IMPORTABLE AS PER INDIA''S FOREGIN TRADE POLICY 2022</p><p class="sub-heading" style="font-size:12px;margin-top:10px">B) THAT THE OIL IS FREE FROM CONMTAMINATION AND SEA WATER AT THE TIME OF SHIPMENT AND THIS CONSIGNMENT DOES NOT CONTAIN BEEF IN ANY FORM</p><p class="sub-heading" style="font-size:12px;margin-top:10px">C) THAT THE FREIGHT CHARGED FOR THIS SHIPMENT IS USD 50 PER MT</p><p class="sub-heading" style="font-size:12px;margin-top:10px">D) THE GOODS ARE OF PAPUA NEW GUINEA ORIGIN</p><p class="sub-heading" style="font-size:12px;margin-top:10px;font-weight:600">QUALITY SPECIFICATION</p><p class="sub-heading" style="font-size:12px;margin-top:10px;text-decoration:underline;font-weight:600">TERMS</p><p class="sub-heading" style="font-size:12px;margin-top:10px">FFA 4.5% MAX</p><p class="sub-heading" style="font-size:12px;margin-top:10px">MN 0.5% MAX</p></div><div class="col-3" style="font-size:14px;font-weight:600"></div><div class="col-3" style="font-size:14px;font-weight:600"></div><div class="col-3" style="font-size:14px;font-weight:600"></div></div><div class="row" style="margin-top:20px"><div class="col-4" style="font-size:14px;font-weight:600"><p class="sub-heading">TOTAL INVOICE VALUE US$</p></div><div class="col-3" style="font-size:14px;font-weight:600"></div><div class="col-3" style="font-size:14px;font-weight:600"></div><div class="col-3" style="font-size:14px;font-weight:600"><p class="sub-heading" style="border-top-style:dotted;border-bottom-style:dotted;padding:10px">##Amount##</p></div></div><div class="row"><div class="col-12" style="margin-top:10px"><p class="sub-heading" style="font-weight:600;font-size:12px">(US DOLLARS ELEVEN MILLION TWENTY SEVEN THOUSAND SIX HUNDERED SEVENTY AND CENT SIXTY THREE ONLY)</p><hr style="background:#000"><p class="sub-heading" style="font-size:12px;font-weight:600">Payment by Telegraphic Transfer to our account as under:</p></div></div><div class="row"><div class="col-12"><table><tr><td style="padding-bottom:10px;font-size:14px">Bank Name</td><td style="padding-bottom:10px;font-size:14px">: HSBC LIMITED, 9 Battery Road #12-01 MYP Centre, SINGAPORE 049910</td></tr><tr><td style="padding-bottom:10px;font-size:14px">Swift Code</td><td style="padding-bottom:10px;font-size:14px">: HSBCSGSG</td></tr><tr><td style="padding-bottom:10px;font-size:14px">Branch Code</td><td style="padding-bottom:10px;font-size:14px">: 7232</td></tr><tr><td style="padding-bottom:10px;font-size:14px">Account Name</td><td style="padding-bottom:10px;font-size:14px">: MGV COMMODITY PTE LTD</td></tr><tr><td style="padding-bottom:10px;font-size:14px">Accont Number(USD)</td><td style="padding-bottom:10px;font-size:14px;font-weight:600">: 25637373889</td></tr></table></div></div><div class="row"><div class="col-12" style="margin-top:10px"><p class="sub-heading" style="font-weight:600;font-style:italic">Please Quote Invoice number in the description filed of the remittance</p><hr style="background:#000"></div></div><div class="row"><div class="col-12"><p class="sub-heading" style="font-weight:600;font-size:16px">MGV COMMODITIY PTE LTD</p></div></div><div class="row"><div class="col-12" style="margin-top:70px"><p class="sub-heading" style="font-weight:600;font-size:14px">AUTHORISED SIGNATORY</p></div></div></div></body></html>',
  'Invoice To Buyer',N'91750679-B6A4-40B4-9FD6-D040664D608A')

    MERGE INTO [dbo].[EmailTemplates] AS Target 
    USING (
	SELECT NEWID(),[EmailTemplateName],[EmailTemplate],[EmailSubject],[EmailTemplateReferenceId],GETUTCDATE(),@UserId,@CompanyId,C.Id
	FROM
	(SELECT [EmailTemplateName],[EmailTemplate]
	 ,[EmailSubject],[EmailTemplateReferenceId]
	 FROM @Template
	 ) T
    INNER JOIN Client C On 1 = 1
	WHERE CompanyId = @CompanyId 
    )
    AS Source ([Id], [EmailTemplateName], [EmailTemplate],[EmailSubject],[EmailTemplateReferenceId],[CreatedDateTime], [CreatedByUserId],[CompanyId],[ClientId]) 
    ON Target.Id = Source.Id  
    WHEN MATCHED THEN 
    UPDATE SET [EmailTemplateName] = Source.[EmailTemplateName],
               [EmailTemplate] = Source.[EmailTemplate],
               [EmailSubject] = Source.[EmailSubject],
               [ClientId] = Source.[ClientId],
               [EmailTemplateReferenceId] = Source.[EmailTemplateReferenceId],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId] = Source.[CompanyId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [EmailTemplateName], [EmailTemplate], [EmailSubject], [ClientId], [EmailTemplateReferenceId], [CreatedDateTime], [CreatedByUserId], [CompanyId]) 
    VALUES ([Id], [EmailTemplateName], [EmailTemplate], [EmailSubject], [ClientId], [EmailTemplateReferenceId], [CreatedDateTime], [CreatedByUserId], [CompanyId]);

	MERGE INTO [dbo].[HtmlTags] AS Target 
	USING ( VALUES
          
           --Freight Certificate
           (NEWID(), N'##VesselName##', N'9FD1866A-9938-446B-BEDE-772FF45C7AD4','This is vessel name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##CommodityName##', N'9FD1866A-9938-446B-BEDE-772FF45C7AD4','This is the commodity name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##CountryName##',N'9FD1866A-9938-446B-BEDE-772FF45C7AD4','This is the country name', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PortOfDischarge##',N'9FD1866A-9938-446B-BEDE-772FF45C7AD4','This is the country name', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'9FD1866A-9938-446B-BEDE-772FF45C7AD4','This is the site url', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'9FD1866A-9938-446B-BEDE-772FF45C7AD4','This is the company logo for registred company', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##BillOfLanding##',N'9FD1866A-9938-446B-BEDE-772FF45C7AD4','This is the date when the bill is generated', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##QuantityUnits##',N'9FD1866A-9938-446B-BEDE-772FF45C7AD4','This is the measurement unit for contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##CurrentDate##',N'9FD1866A-9938-446B-BEDE-772FF45C7AD4','This is the date when the pdf is generated', @CompanyId, GETDATE(), @UserId, NULL)
           
           -- Shelf life certificate
           ,(NEWID(), N'##VesselName##', N'C6E1B4C1-A5BC-4D2A-944C-E901B70B80F7','This is vessel name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##CommodityName##', N'C6E1B4C1-A5BC-4D2A-944C-E901B70B80F7','This is the commodity name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##CountryName##',N'C6E1B4C1-A5BC-4D2A-944C-E901B70B80F7','This is the country name', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PortOfDischarge##',N'C6E1B4C1-A5BC-4D2A-944C-E901B70B80F7','This is the country name', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'C6E1B4C1-A5BC-4D2A-944C-E901B70B80F7','This is the site url', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'C6E1B4C1-A5BC-4D2A-944C-E901B70B80F7','This is the company logo for registred company', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##BillOfLanding##',N'C6E1B4C1-A5BC-4D2A-944C-E901B70B80F7','This is the date when the bill is generated', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##QuantityUnits##',N'C6E1B4C1-A5BC-4D2A-944C-E901B70B80F7','This is the measurement unit for contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##CurrentDate##',N'C6E1B4C1-A5BC-4D2A-944C-E901B70B80F7','This is the date when the pdf is generated', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ManufactureDate##',N'C6E1B4C1-A5BC-4D2A-944C-E901B70B80F7','This is the measurement unit for contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##ExpiryDate##',N'C6E1B4C1-A5BC-4D2A-944C-E901B70B80F7','This is the date when the pdf is generated', @CompanyId, GETDATE(), @UserId, NULL)

              --Certificate of origin Certificate
           ,(NEWID(), N'##VesselName##', N'7E33FF11-BE4C-41DF-BE28-0D1295B14AC3','This is vessel name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##CommodityName##', N'7E33FF11-BE4C-41DF-BE28-0D1295B14AC3','This is the commodity name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##CountryName##',N'7E33FF11-BE4C-41DF-BE28-0D1295B14AC3','This is the country name', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##PortOfDischarge##',N'7E33FF11-BE4C-41DF-BE28-0D1295B14AC3','This is the country name', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##siteUrl##',N'7E33FF11-BE4C-41DF-BE28-0D1295B14AC3','This is the site url', @CompanyId, GETDATE(), @UserId, NULL)
		   ,(NEWID(), N'##CompanyLogo##',N'7E33FF11-BE4C-41DF-BE28-0D1295B14AC3','This is the company logo for registred company', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##BillOfLanding##',N'7E33FF11-BE4C-41DF-BE28-0D1295B14AC3','This is the date when the bill is generated', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##QuantityUnits##',N'7E33FF11-BE4C-41DF-BE28-0D1295B14AC3','This is the measurement unit for contract quantity', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##CurrentDate##',N'7E33FF11-BE4C-41DF-BE28-0D1295B14AC3','This is the date when the pdf is generated', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Signature##',N'7E33FF11-BE4C-41DF-BE28-0D1295B14AC3','This is the signature', @CompanyId, GETDATE(), @UserId, NULL)
           
           --InvoiceToBuyerStepEmailTemplate
           ,(NEWID(), N'##InvoiceNumber##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the invoice number', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##IssueDate##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the date of issued', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##BuyerName##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the name of the buyer', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##BuyerAddressLine1##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the buyer address line1', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##BuyerAddressLine2##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the buyer address line2', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##PortLoad##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the port of loading', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##PortDischarge##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the port of discharge', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##BLNoAndDate##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the BL no and Date', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##VesselName##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the Vessel name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##PaymentTerms##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the payment terms', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##DraweesBank##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the drawees bank details', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Quantity##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the Quantity of good', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##UnitPrice##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the unit price of good', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Amount##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the amount for quantity of good', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'B221C937-CE8C-4146-8498-9CB9CA579140','This is the commodity name', @CompanyId, GETDATE(), @UserId, NULL)
           --InvoiceFromSellerStepEmailTemplate
           ,(NEWID(), N'##InvoiceNumber##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the invoice number', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##IssueDate##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the date of issued', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##BuyerName##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the name of the buyer', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##BuyerAddressLine1##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the buyer address line1', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##BuyerAddressLine2##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the buyer address line2', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##PortLoad##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the port of loading', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##PortDischarge##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the port of discharge', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##BLNoAndDate##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the BL no and Date', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##VesselName##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the Vessel name', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##PaymentTerms##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the payment terms', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##DraweesBank##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the drawees bank details', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Quantity##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the Quantity of good', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##UnitPrice##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the unit price of good', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Amount##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the amount for quantity of good', @CompanyId, GETDATE(), @UserId, NULL)
           ,(NEWID(), N'##Commodity##',N'91750679-B6A4-40B4-9FD6-D040664D608A','This is the commodity name', @CompanyId, GETDATE(), @UserId, NULL)
          
           ) 
	AS Source ([Id], [HtmlTagName],[HtmlTemplateId],[Description], [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [HtmlTagName] = Source.[HtmlTagName],
	           [HtmlTemplateId] = Source.[HtmlTemplateId],
	           [Description] = Source.[Description],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [InActiveDateTime] = Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET AND Source.[HtmlTemplateId] IS NOT NULL THEN 
	INSERT ([Id], [HtmlTagName],[HtmlTemplateId],[Description], [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]) 
	VALUES ([Id], [HtmlTagName],[HtmlTemplateId],[Description], [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]);

    MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
     (NEWID(),'This app can be used to update the name and color of a RFQ status. These contract status are used in RFQ and its process.', N'RFQ status', CAST(N'2021-10-07 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
	)
    AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    ON Target.[WidgetName] = Source.[WidgetName] AND Target.[CompanyId] = Source.[CompanyId]
    WHEN MATCHED THEN 
    UPDATE SET [WidgetName] = Source.[WidgetName],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId] =  Source.[CompanyId],
               [Description] =  Source.[Description],
               [UpdatedDateTime] =  Source.[UpdatedDateTime],
               [UpdatedByUserId] =  Source.[UpdatedByUserId],
               [InActiveDateTime] =  Source.[InActiveDateTime]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

     MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
        USING (VALUES 
        (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'RFQ status' AND CompanyId = @CompanyId),'05E222F2-6EA3-4CA6-8788-52416E67475F',@UserId,@Currentdate)
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

    MERGE INTO [dbo].[WidgetRoleConfiguration] AS Target 
	USING ( VALUES
        (NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'RFQ status'),@RoleId,GETDATE(),@UserId)
           ) 
    AS Source (Id,WidgetId,RoleId,CreatedDateTime,CreatedByUserId)
    ON Target.WidgetId = Source.WidgetId AND Target.RoleId = Source.RoleId  
	WHEN MATCHED THEN 
    UPDATE SET [RoleId] = Source.[RoleId],
                WidgetId = Source.WidgetId,
	           [CreatedDateTime] = Source.[CreatedDateTime],
                [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], WidgetId, RoleId, [CreatedDateTime], [CreatedByUserId]) 
    VALUES ([Id], WidgetId, RoleId, [CreatedDateTime], [CreatedByUserId]);
END
GO