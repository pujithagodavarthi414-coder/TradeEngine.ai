CREATE PROCEDURE [dbo].[Marker345]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
  

Update HtmlTemplates SET HtmlTemplate = '<!DOCTYPE html>
<html>
<style>
    .div {
        box-sizing: border-box
    }

    .p-1 {
        padding: 1rem !important
    }

    h6 {
        font-size: 1rem;
        margin-bottom: .5rem;
        font-weight: 400;
        line-height: 1.1;
        color: inherit;
        margin-top: 0
    }

    .fxLayout-row {
        flex-flow: row wrap;
        box-sizing: border-box;
        display: flex
    }

    .fxFlex48 {
        flex: 1 1 100%;
        box-sizing: border-box;
        max-width: 48%
    }

    .fxFlex {
        flex: 1 1 0%;
        box-sizing: border-box
    }

    .fxFlex49-column {
        flex: 1 1 100%;
        box-sizing: border-box;
        flex-direction: column;
        display: flex;
        max-width: 49%
    }

    .fxFlex50-row-start {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: center flex-start;
        align-items: center;
        flex-direction: row;
        display: flex;
        max-width: 50%
    }

    .fxFlex50-column-start {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: center flex-start;
        align-items: center;
        flex-direction: column;
        display: block;
        max-width: 50%
    }

    .fxFlex50-column-end {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: flex-start flex-end;
        align-items: center;
        flex-direction: column;
        display: block;
        max-width: 50%
    }

    .fxFlex100 {
        flex: 1 1 100%;
        box-sizing: border-box;
        max-width: 100%
    }

    .fxFlex100-end {
        flex: 1 1 100%;
        box-sizing: border-box;
        place-content: flex-start flex-end;
        align-items: flex-start;
        flex-direction: row;
        display: flex;
        max-width: 100%
    }

    .fxLayout-end {
        place-content: center flex-end;
        align-items: center;
        flex-direction: row;
        box-sizing: border-box;
        display: flex
    }

    .word-break {
        word-break: break-word !important
    }

    .d-block {
        display: bloack !important
    }

    .mb-1 {
        margin-bottom: 1rem !important
    }

    .mt-02 {
        margin-top: .3rem !important
    }

    .mt-1 {
        margin-top: 1rem !important
    }

    .mt-1-05 {
        margin-top: 1.5rem
    }

    .ml-1 {
        margin-left: 1rem !important
    }

    .mt-05 {
        margin-top: .5rem !important
    }

    .mr-05 {
        margin-right: .5rem !important
    }

    .invoice-amount-price {
        font-size: 23px;
        font-weight: 700;
        position: relative;
        top: 1px
    }

    .overflow-visible {
        overflow: visible
    }

    .table-responsive {
        display: block;
        width: 100%;
        overflow-x: auto;
        -webkit-overflow-scrolling: touch
    }

    .mb-0 {
        margin-bottom: 0 !important
    }

    .table {
        width: 100%;
        margin-bottom: 1rem;
        color: #212529
    }

    table {
        border-collapse: collapse
    }

    .invoice-container td:first-child,
    .invoice-container th:first-child {
        text-align: inherit;
        padding-left: 0;
        width: 40%
    }

    .table thead th {
        vertical-align: bottom;
        border-bottom: 2px solid #dee2e6
    }

    .invoice-container td,
    .invoice-container th {
        padding-right: 0;
        text-align: right;
        width: 13%
    }

    .invoice-entry-from-container {
        margin-right: 2cm;
        margin-left: 2cm;
        margin-top: 2.5cm
    }

    .invoice-entry-from-container-margin-left {
        margin-right: 2cm
    }

    .table td,
    .table th {
        padding: .75rem;
        vertical-align: top;
        border-top: 1px solid #dee2e6
    }

    td {
        page-break-before: always
    }

    th {
        page-break-before: always
    }

    @page {
        margin-top: 10px;
        margin-bottom: 10px
    }
</style>

<body>
	<center style="margin-top:2cm">
        <h6><b class="page-font">FACTURE DE CONSOMMATION ELECTRIQUE</b></h6>
    </center>
    <center>
        <h6><b class="page-font">##FileName##</b></h6>
    </center>
    <div class="invoice-preview-height">
        <style>
            .d {
                border-bottom: 1px solid #ddd
            }

            .page-font {
                font-size: 10px
            }

            .a {
                border: 1px solid #ddd;
                text-align: left;
                width: 95%;
                border-collapse: collapse;
                font-size: 10px
            }

            .b {
                text-align: left;
                padding: 6px;
                width: 20px;
                border-collapse: collapse;
                word-break: break-word;
                font-size: 10px
            }

            table {
                page-break-inside: auto
            }

            th {
                font-weight: 400
            }

            .c {
                border-top: 1px solid #ddd
            }
			
			.e{
				border-bottom: double;
			}
        </style>
        <div class="invoice-container">
            <div style="display:flex">
                <div class="fxLayout-row">
                    <div class="fxFlex50-start d-block word-break page-font" style="margin-left:0.5cm">PHOTON ONE SA<br>Pré de la Joux-Dessous
                        1<br>1635 La Tour-de-Trême<br>No TVA : CHE-303.848.436 TVA<br>Email :
                        mfs.merchant.finance@gmail.com<br>Tél. : 079-221.71.42</div>
                </div>
                <div class="d-block word-break page-font" style="margin-left:4.7cm;margin-top:0.3cm;height:2cm;width:4.5cm">##Address##</div>
            </div>
        </div>
    </div>
    <div>
        <div class="fxLayout-row">
            <div class="fxFlex50-column-start mb-1">
                <div class="fxFlex100"></div>
            </div>
            <div class="fxFlex50-column-end">
                <div class="fxFlex100-end mt-02"><span class="page-font" style="text-align:right;margin-right:4cm">La
                        Tour-de-Trême, le : ##GridInvoiceDate##</span></div>
            </div>
        </div>
    </div>
    <center>
        <table class="a" style="margin-bottom:10px;margin-right:0.5cm;margin-left:0.25cm;border:none">
            <tr>
                <th class="d b">
                    <center style="padding-top:23px">Pièce</center>
                </th>
                <th class="d">
                    <center style="padding-top:23px">Du</center>
                </th>
                <th class="d">
                    <center style="padding-top:23px">Au</center>
                </th>
                <th class="d">
                    <center style="padding-top:2px"><b>P<br>kWh</b><br>Production</center>
                </th>
                <th class="d">
                    <center style="padding-top:2px"><b>R<br>kWh</b><br>Reprise</center>
                </th>
                <th class="d">
                    <center style="padding-top:2px"><b>A<br>kWh</b><br>Auto-consommation</center>
                </th>
                <th class="d">
                    <center style="padding-top:23px">%</center>
                </th>
                <th class="d">
                    <center style="padding-top:23px">Cts/kWh</center>
                </th>
                <th class="d">
                    <center style="padding-top:23px">CHF</center>
                </th>
            </tr>
            <tr>
                <td class="b" style="width: 2.8cm">##praName##</td>
                <td class="b" style="width:50px">
                    <center>##StartDate##</center>
                </td>
                <td class="b" style="width:50px">
                    <center>##EndDate##</center>
                </td>
                <td class="b" style="width: 3.5cm">
                    <center>##Production##</center>
                </td>
                <td class="b">
                    <center>##Reprise##</center>
                </td>
                <td class="b">
                    <center>##Autoconsommation##</center>
                </td>
                <td class="b">
                    <center>##Percentage##</center>
                </td>
                <td class="b">
                    <center>##AutoCTariff##</center>
                </td>
                <td class="b">
                    <center>##AutoConsumptionSum##</center>
                </td>
            </tr>
            <tr> ##Prastring##</tr>
            <tr>
                <td class="b">Sous-Total</td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center>PV</center>
                </td>
                <td class="c">
                    <center><b>##FacturationSum##<b></center>
                </td>
            </tr>
            <!-- <tr> -->
                <!-- <td class="b" style="width: 2.8cm">##praName##</td> -->
                <!-- <td class="b" style="width:50px"> -->
                    <!-- <center>##StartDate##</center> -->
                <!-- </td> -->
                <!-- <td class="b" style="width:50px"> -->
                    <!-- <center>##EndDate##</center> -->
                <!-- </td> -->
                <!-- <td class="b" style="width: 3cm"> -->
                    <!-- <center></center> -->
                <!-- </td> -->
                <!-- <td class="b"> -->
                    <!-- <center></center> -->
                <!-- </td> -->
                <!-- <td class="b"> -->
                    <!-- <center>##AdministrationRomandeE##</center> -->
                <!-- </td> -->
                <!-- <td class="b"> -->
                    <!-- <center></center> -->
                <!-- </td> -->
                <!-- <td class="b"> -->
                    <!-- <center></center> -->
                <!-- </td> -->
                <!-- <td class="b"> -->
                    <!-- <center></center> -->
                <!-- </td> -->
				<!-- ##AdministrationRomandeERender## -->
            <!-- </tr> -->
            
         
            <tr>##DFstring##</tr>
            <tr>
                <td class="b"></td>
                <td class="b" style="width:50px">
                    <center></center>
                </td>
                <td class="b" style="width:50px">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b" style="width:40px">
                    <center>##grdName##</center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center><b>##Distribution##</b></center></center>
                </td>
            </tr>
           
            <tr>
                <td class="b">Total</td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center>##SubTotal##</center>
                </td>
            </tr>
            <tr>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
            </tr>
            <tr>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center>TVA</center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center>##TVA##%</center>
                </td>
                <td class="b">
                    <center><b>##TVAForSubTotal##</b></center>
                </td>
            </tr>
            <tr>
                <td class="b">Total</td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center>##tvaValue##</center>
                </td>
            </tr>
            <tr>
                <td class="b">Arrondi</td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center>##Arrondi##</center>
                </td>
            </tr>
            <tr>
                <td class="b">Montant à payer</td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="c e">
                    <center><b>##TotalValue##</b></center>
                </td>
            </tr>
        </table>
    </center>
    <p class="page-font" style="margin-left:0.5cm">Payable net à 10 jours</p>
    <p class="page-font" style="margin-left:0.5cm">Nous vous remercions d''avance d''effectuer votre règlement à:</p>
    <p class="page-font" style="margin-left:0.5cm">Bénéficiaire :##Beneficiaire##<br>IBAN: ##Iban##<br>Banque: ##Banque##
    </p>
    <p class="page-font" style="margin-left:0.5cm">Merci de votre collaboration</p>
</body>

</html>'
WHERE TemplateName = 'InvoicePDFRomandeETemplate'



Update HtmlTemplates SET HtmlTemplate = '<!DOCTYPE html>
<html>
<style>
    .div {
        box-sizing: border-box
    }

    .p-1 {
        padding: 1rem !important
    }

    h6 {
        font-size: 1rem;
        margin-bottom: .5rem;
        font-weight: 400;
        line-height: 1.1;
        color: inherit;
        margin-top: 0
    }

    .fxLayout-row {
        flex-flow: row wrap;
        box-sizing: border-box;
        display: flex
    }

    .fxFlex48 {
        flex: 1 1 100%;
        box-sizing: border-box;
        max-width: 48%
    }

    .fxFlex {
        flex: 1 1 0%;
        box-sizing: border-box
    }

    .fxFlex49-column {
        flex: 1 1 100%;
        box-sizing: border-box;
        flex-direction: column;
        display: flex;
        max-width: 49%
    }

    .fxFlex50-row-start {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: center flex-start;
        align-items: center;
        flex-direction: row;
        display: flex;
        max-width: 50%
    }

    .fxFlex50-column-start {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: center flex-start;
        align-items: center;
        flex-direction: column;
        display: block;
        max-width: 50%
    }

    .fxFlex50-column-end {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: flex-start flex-end;
        align-items: center;
        flex-direction: column;
        display: block;
        max-width: 50%
    }

    .fxFlex100 {
        flex: 1 1 100%;
        box-sizing: border-box;
        max-width: 100%
    }

    .fxFlex100-end {
        flex: 1 1 100%;
        box-sizing: border-box;
        place-content: flex-start flex-end;
        align-items: flex-start;
        flex-direction: row;
        display: flex;
        max-width: 100%
    }

    .fxLayout-end {
        place-content: center flex-end;
        align-items: center;
        flex-direction: row;
        box-sizing: border-box;
        display: flex
    }

    .word-break {
        word-break: break-word !important
    }

    .d-block {
        display: bloack !important
    }

    .mb-1 {
        margin-bottom: 1rem !important
    }

    .mt-02 {
        margin-top: .3rem !important
    }

    .mt-1 {
        margin-top: 1rem !important
    }

    .mt-1-05 {
        margin-top: 1.5rem
    }

    .ml-1 {
        margin-left: 1rem !important
    }

    .mt-05 {
        margin-top: .5rem !important
    }

    .mr-05 {
        margin-right: .5rem !important
    }

    .invoice-amount-price {
        font-size: 23px;
        font-weight: 700;
        position: relative;
        top: 1px
    }

    .overflow-visible {
        overflow: visible
    }

    .table-responsive {
        display: block;
        width: 100%;
        overflow-x: auto;
        -webkit-overflow-scrolling: touch
    }

    .mb-0 {
        margin-bottom: 0 !important
    }

    .table {
        width: 100%;
        margin-bottom: 1rem;
        color: #212529
    }

    table {
        border-collapse: collapse
    }

    .invoice-container td:first-child,
    .invoice-container th:first-child {
        text-align: inherit;
        padding-left: 0;
        width: 40%
    }

    .table thead th {
        vertical-align: bottom;
        border-bottom: 2px solid #dee2e6
    }

    .invoice-container td,
    .invoice-container th {
        padding-right: 0;
        text-align: right;
        width: 13%

    .table td,
    .table th {
        padding: .75rem;
        vertical-align: top;
        border-top: 1px solid #dee2e6
    }

    td {
        page-break-before: always
    }

    th {
        page-break-before: always
    }

    @page {
        margin-top: 10px;
        margin-bottom: 10px
    }
</style>

<body>
	<center style="margin-top:2cm">
        <h6><b class="page-font">FACTURE DE CONSOMMATION ELECTRIQUE</b></h6>
    </center>
    <center>
        <h6><b class="page-font">##FileName##</b></h6>
    </center>
    <div class="invoice-preview-height">
        <style>
            .d {
                border-bottom: 1px solid #ddd
            }

            .page-font {
                font-size: 10px
            }

            .a {
                border: 1px solid #ddd;
                text-align: left;
                
                width: 95%;
                border-collapse: collapse;
                font-size: 10px
            }

            .b {
                text-align: left;
                padding: 6px;
                width: 20px;
                border-collapse: collapse;
                word-break: break-word;
                font-size: 10px
            }

            table {
                page-break-inside: auto
            }

            th {
                font-weight: 400
            }

            .c {
                border-top: 1px solid #ddd
            }
			
			.e{
				border-bottom: double;
			}
        </style>
        <div class="invoice-container">
            <div style="display:flex">
                <div class="fxLayout-row">
                    <div class="fxFlex50-start d-block word-break page-font" style="margin-left:0.5cm">
                        PHOTON ONE SA<br>Pré de la Joux-Dessous 1<br>1635 La Tour-de-Trême<br>No TVA : CHE-303.848.436
                        TVA<br>Email : mfs.merchant.finance@gmail.com<br>Tél. : 079-221.71.42</div>
                </div>
                <div class="d-block word-break page-font" style="margin-left:4.7cm;margin-top:0.3cm;height:2cm;width:4.5cm">##Address##</div>
            </div>
        </div>
    </div>
    <div>
        <div class="fxLayout-row">
            <div class="fxFlex50-column-start mb-1">
                <div class="fxFlex100"></div>
            </div>
            <div class="fxFlex50-column-end">
                <div class="fxFlex100-end mt-02"><span class="page-font" style="text-align:right;margin-right:4cm">La
                        Tour-de-Trême, le : ##GridInvoiceDate##</span></div>
            </div>
        </div>
    </div>
    
    <center>
        <table class="a" style="margin-bottom:10px;margin-right:0.5cm;margin-left:0.25cm;border:none">
            <tr>
                <th class="d b">
                    <center style="padding-top:23px">Pièce</center>
                </th>
                <th class="d">
                    <center style="padding-top:23px">Du</center>
                </th>
                <th class="d">
                    <center style="padding-top:23px">Au</center>
                </th>
                <th class="d">
                    <center style="padding-top:2px"><b>P<br>kWh</b><br>Production</center>
                </th>
                <th class="d">
                    <center style="padding-top:2px"><b>R<br>kWh</b><br>Reprise</center>
                </th>
                <th class="d">
                    <center style="padding-top:2px"><b>A<br>kWh</b><br>Auto<br>consommation</center>
                </th>
                <th class="d">
                    <center style="padding-top:23px">%</center>
                </th>
                <th class="d">
                    <center style="padding-top:23px">Cts/kWh</center>
                </th>
                <th class="d">
                    <center style="padding-top:23px">CHF</center>
                </th>
            </tr>
            <tr>
                <td class="b" style="width: 2.8cm">##praName##</td>
                <td class="b" style="width:50px">
                    <center>##StartDate##</center>
                </td>
                <td class="b" style="width:50px">
                    <center>##EndDate##</center>
                </td>
                <td class="b" style="width: 3.5cm">
                    <center>##Production##</center>
                </td>
                <td class="b">
                    <center>##Reprise##</center>
                </td>
                <td class="b">
                    <center>##Autoconsommation##</center>
                </td>
                <td class="b">
                    <center>##Percentage##</center>
                </td>
                <td class="b">
                    <center>##AutoCTariff##</center>
                </td>
                <td class="b">
                    <center>##AutoConsumptionSum##</center>
                </td>
            </tr>
            
            <tr> ##Prastring##</tr>
            <tr>
                <td class="b">Sous-Total</td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center>PV</center>
                </td>
                <td class="c">
                    <center><b>##FacturationSum##</b></center>
                </td>
            </tr>
           
            
            <tr>##HautTariff##</tr>
            <tr>##BasTariff##</tr>
            <tr>##TotalTariff##</tr>
            <tr>##DFstring##</tr>
            <tr>
                <td class="b"></td>
                <td class="b" style="width:50px">
                    <center></center>
                </td>
                <td class="b" style="width:50px">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b" style="width:40px">
                    <center>##grdName##</center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center><b>##Distribution##</b></center></center>
                </td>
            </tr>
           
            <tr>
                <td class="b">Total</td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center><b>##SubTotal##</b></center>
                </td>
            </tr>
            <tr>
                <td class="b"></td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center>TVA</center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center>##TVA##%</center>
                </td>
                <td class="b">
                    <center>##TVAForSubTotal##</center>
                </td>
            </tr>
            <tr>
                <td class="b">Total</td>
                <td class="b"></td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="c">
                    <center><b>##Total##</b></center>
                </td>
            </tr>
            <tr>
                <td class="b">Arrondi</td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center>##Arrondi##</center>
                </td>
            </tr>
            <tr>
                <td class="b">Montant à payer</td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="b">
                    <center></center>
                </td>
                <td class="c e">
                    <center><b>##TotalValue##</b></center>
                </td>
            </tr>
        </table>
    </center>
    <p class="page-font" style="margin-left:0.5cm">Payable net à 10 jours</p>
    <p class="page-font" style="margin-left:0.5cm">Nous vous remercions d''avance d''effectuer votre règlement à:</p>
    <p class="page-font" style="margin-left:0.5cm">Bénéficiaire :##Beneficiaire##<br>IBAN: ##Iban##<br>Banque: ##Banque##
    </p>
    <p class="page-font" style="margin-left:0.5cm">Merci de votre collaboration</p>
</body>

</html>'
WHERE TemplateName = 'InvoicePDFGroupeETemplate'
END
GO