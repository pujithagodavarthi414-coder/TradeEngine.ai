CREATE PROCEDURE [dbo].[Marker432]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN
UPDATE EmailTemplates SET EmailTemplate = '<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MGV COMMODITY PTE LTD</title>
    <style>
        #pageborder {
            position: fixed;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;

        }

        @page {
            margin: 1.5cm;

            @top-center {
                content: element(pageHeader);
            }

            @bottom-center {
                content: element(pageFooter);
            }
        }

        #pageHeader {
            position: running(pageHeader);
        }

        #pageFooter {
            position: running(pageFooter);
        }

        body {
            background-color: #F6F6F6;
            margin: 0;
            padding: 0;
        }

        h1,
        h2,
        h3,
        h4,
        h5,
        h6 {
            margin: 0;
            padding: 0;
        }

        p {
            margin: 0;
            padding: 0;
        }

        .container {
            width: 95%;
            margin-right: auto;
            margin-left: auto;
        }

        .row {
            display: flex;
            flex-wrap: wrap;
        }

        .col-6 {
            width: 50%;
            flex: 0 0 auto;
        }

        .col-4 {
            width: 25%;
            flex: 0 0 auto;
        }

        .col-8 {
            width: 74%;
            flex: 0 0 auto;
        }

        .col-12 {
            width: 100%;
            flex: 0 0 auto;
        }

        .sub-heading {
            color: #262626;
            margin-bottom: 05px;
        }
    </style>
</head>

<body>
    <div class="container">
        <div id="pageborder">
        </div>
        <div class="body-section">
            <div class="row">
                <div class="col-12">
                    <div style="text-align: center;">##CompanyLogo##</div>
                    <p class="sub-heading" style="text-align: center; color: red; font-size: 40px;">##CompanyName##</p>
                    <p class="sub-heading" style="text-align: center;">##CompanyAddress##</p>
                    <p class="sub-heading" style="text-align: center;">##RegistrationNumberAndPhoneNumber##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <p class="sub-heading">##ContractType## CONTRACT NO: ##ContractNo##</p>
                    <p class="sub-heading">We hereby confirm the following trade done on ##ContractDate##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <table>
                        <tr>
                            <td style="padding-bottom: 15px;">Seller</td>
                            <td style="padding-bottom: 15px;">: ##SellerAddress##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 15px;">Buyer</td>
                            <td style="padding-bottom: 15px;">: ##BuyerAddress##
                            <td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 15px;">Product</td>
                            <td style="padding-bottom: 15px;">: ##ProductName##
                            <td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 15px;">PortOfLoading</td>
                            <td style="padding-bottom: 15px;">: ##PortOfLoading##
                            <td>
                        </tr>
						<tr>
                            <td style="padding-bottom: 15px;">PortOfLoadingCountry</td>
                            <td style="padding-bottom: 15px;">: ##PortOfLoadingCountry##
                            <td>
                        </tr>
						<tr>
						    <td style="padding-bottom: 15px;">PortOfDischarge</td>
                            <td style="padding-bottom: 15px;">: ##PortOfDischarge##
                            <td>
                        </tr>
						<tr>
                            <td style="padding-bottom: 15px;">PortOfDischargeCountry</td>
                            <td style="padding-bottom: 15px;">: ##PortOfDischargeCountry##
                            <td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 15px;">Specification</td>
                            <td style="padding-bottom: 15px;">: ##Specifications##
                            <td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 15px;">Quantity & Tolerance</td>
                            <td style="padding-bottom: 15px;">: ##QuantityAndTolrance##
                            <td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 15px;">Price</td>
                            <td style="padding-bottom: 15px;">: ##Price##
                            <td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 15px;">Basis</td>
                            <td style="padding-bottom: 15px;">: ##Basis##
                            <td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 15px;">Weight / Quality</td>
                            <td style="padding-bottom: 15px;">: ##WeightPerQuantity##
                            <td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 15px;">Shipment Period</td>
                            <td style="padding-bottom: 15px;">: ##ShipmentPeriod##
                            <td>
                        </tr>
                        <tr>
                            <td style="padding-bottom: 15px;">Payment Term</td>
                            <td style="padding-bottom: 15px;">: ##PaymentTerm##
                            <td>
                        </tr>
                    </table>
                    <table>
                        <div style="padding-bottom:10px">##TermsAndConditions##</div>
                        <table>
                            <tr>
                                <td style="padding-bottom: 15px; width:140px">Documents</td>
                                <td style="padding-bottom: 15px;">: ##Documents##
                                <td>
                            </tr>
                        </table>
                </div>
            </div>
            Please sign and return if not signed within 48 hrs. its deemed contract Confirmed and Accepted by both
            parties:
            Confirmed and Accepted by both parties:
            <div class="row" style="margin-top: 20px;">
                <div class="col-6">
                    ##SellerSignature##
                    <hr style="border-top: 3px dotted; width: 315px;">
                    <p class="sub-heading" style="text-align: center; margin-bottom: 15px;">##SellerName##</p>
                    <p class="sub-heading" style="text-align: center;">(As SELLERS)</p>
                </div>
                <div class="col-6">
                    ##BuyerSignature##
                    <hr style="border-top: 3px dotted; width: 315px;">
                    <p class="sub-heading" style="text-align: center; margin-bottom: 15px;">##BuyerName##</p>
                    <p class="sub-heading" style="text-align: center;">(As BUYERS)</p>
                </div>
            </div>
        </div>
    </div>
</body>

</html>' WHERE EmailTemplateName = 'ContractFinalPdfTemplate'
END