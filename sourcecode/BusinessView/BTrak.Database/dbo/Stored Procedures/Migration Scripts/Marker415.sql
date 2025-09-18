CREATE PROCEDURE [dbo].[Marker415]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
    update emailtemplates set EmailTemplate = '<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>INVOICE</title>
        <style>
        #pageborder {
            position: fixed;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            border: 2px solid black;
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
        @media print {
            .terms-page-break {
                page-break-before: always;
            }
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
    
            .brand-section {
                background-color: #0d1033;
                padding: 10px 40px;
            }
    
            .row {
                display: flex;
                flex-wrap: wrap;
            }
    
            .col-6 {
                width: 50%;
                flex: 0 0 auto;
            }
    
            .text-white {
                color: #fff;
            }
    
            .company-details {
                float: right;
                text-align: right;
            }
    

    
            .heading {
                font-size: 20px;
                margin-bottom: 08px;
            }
    
            .sub-heading {
                color: #262626;
                margin-bottom: 05px;
            }
    
            .w-20 {
                width: 20%;
            }
    
            .float-right {
                float: right;
            }
    
            span {
                text-decoration: underline;
                color: blue;
            }
        </style>
    </head>
    
    <body>
        <div class="container">
        <div id="pageborder">
        </div>
            <div class="body-section">
                <div class="row">
                    <div class="col-6">
                        <p style="margin-top:10px">Shipped in apparent good order and condition by</p>
                        <hr style="background: blue;">
                        <p class="sub-heading">Shipper</p>
                    </div>
                    <div class="col-6">
                        <p class="sub-heading" style="margin-left: 50px; font-size: 26px; font-weight: bolder;margin-top:10px">Tanker Bill
                            of Landing</p>
                        <p class="sub-heading" style="margin-left: 50px; font-weight: bolder;">B/L NO. CY/DMI/HAL-02</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <p class="sub-heading">##Shipper##</p>
                        <hr style="background: blue;">
                        <p class="sub-heading">Consignee/Order of</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-6">
                        <p class="sub-heading">TO ORDER</p> <br>
                        <hr style="background: blue;">
                        <p class="sub-heading">Notify Address</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <p class="sub-heading">##NotifyAddress##</p>
                    </div>
                </div>
                <div class="col-12">
                    <hr style="background: blue;">
                </div>
                <div class="row">
                    <div class="col-4">
                        <p class="sub-heading">On Board the tanker</p>
                        <p class="sub-heading">##OnBoardTanker##</p>
                    </div>
                    <div class="col-4" style="margin-left: 50px;">
                        <p class="sub-heading">Flag</p>
                        <p class="sub-heading">##Flag##</p>
                    </div>
                    <div class="col-4" style="margin-left: 50px;">
                        <p class="sub-heading">Master</p>
                        <p class="sub-heading">##Master##</p>
                    </div>
                </div>
                <div class="col-12">
                    <hr style="background: blue;">
                </div>
                <div class="row">
                    <div class="col-4">
                        <p class="sub-heading">Loaded at the port of</p>
                        <p class="sub-heading">##LoadedAtPort##</p>
                    </div>
                    <div class="col-4" style="margin-left: 50px;">
                        <p class="sub-heading">To be delivered to the port of</p>
                        <p class="sub-heading">##DeliveredPort##</p>
                    </div>
                    <div class="col-4" style="margin-left: 50px;">
                        <p class="sub-heading">Voyage Number</p>
                        <p class="sub-heading">##VoyageNumber##</p>
                    </div>
                </div>
                <div class="col-12">
                    <hr style="background: blue;">
                    <p class="sub-heading" style="margin-bottom: 10px;">A Quantity in bulk said by the Shipper to be:</p>
                </div>
                <div class="row">
                    <div class="col-6">
                        <p class="sub-heading">COMMODITY (Name of product)</p>
                        <p class="sub-heading">##Commodity##</p>
                    </div>
                    <div class="col-6">
                        <p class="sub-heading" style="margin-left: 50px;">QUANTITY (lbs, tonnes, barrels, gallons</p>
                        <p class="sub-heading" style="margin-left: 50px;">##Quantity##</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12" style="margin-top: 20px;">
                        <p class="sub-heading">OCEAN CARRIAGE STOWAGE: ##OceanCarriageStowage##</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12" style="margin-top: 20px;">
                        <p class="sub-heading">This shipment of <span> ##Quantity## </span> Metrie tons was loaded on board
                            the Vessel as part of one original lot of <span> ##Quantity## </span> Metrie tons stowed in
                            <span> ##SLOPS## </span> with no segregation as to parcels. For the whole shipment <span>
                                ##TotalBlNumbers## </span> set Of Bill of Lading have been issued for which the Vessel is
                            relieved from all responsibilities to the extent it would be if one sel only would have been
                            issued. The Vessel undertakes to deliver only that portion of the cargo actually loaded which is
                            represented by the percentage that the total amount specifed in the Bill(s) of Lading bears to
                            the foal of the commingling shipment delivered at destination. Neither the Vessel nor the overs
                            assume any responsibility for the consequences of such commingling nor for the separation
                            thereof at the time of delivery. </p>
                        <p class="sub-heading" style="margin-top: 10px;">The quantity, measurement, weight, gauge, quality,
                            nature and value and actual condilion of the cargo unknorm to the Vessel and the Maser, lo be
                            delivered to the port of discharge or so near there to as the Vessel can safely get, always a
                            float upon prior payment of freight as agreed. Cargo is warranted free of danger to Vessel
                            except for the usual risks inherent in the carriage of the commodity as described.</p>
                        <p class="sub-heading" style="margin-top: 10px;">This shipment is carried under and pursuant to the
                            forms of the Charter daled <span> ##CharteredDate## </span> Between <span> AS PER CHARTER
                                PARTY </span> As Owners and <span> AS PER CHARTER PARTY </span> As Charterers, and all
                            conditions. Liberties And exception whatsoever of the said Charier apply to and govern the
                            rights of the parties concerned in this shipment. The Clause Paramount, New Jason Clause and
                            Both to Blame Collision Clause as set out on the reverse of this Bill of Lading are hereby
                            incorpornled herein and shall remain in effect even if unenforceable in the United States of
                            America, General Average payment according to the York-Antwerp Rules 1974, as amended 1994.</p>
                        <p class="sub-heading">The Master is authorized to act for all interests in arranging for salvage
                            assistance on lerms of Lloyds Open Form. The freight is payable discountless and is earned
                            concurrent with loading, ship and/or cargo lost or not lost or abandoned. </p>
                        <p class="sub-heading">The Overs shall have an absolute lien on he cargo for all freight.
                            Deadfreight, demurrage, damages for detention and all other monies due under the above mentioned
                            Charter or under this Bill of Lading, logether with the costs and expenses, including attorneys
                            fees, of recovering same, and shall be antitled to sell or otherwise dispose of the property
                            lined and apply the proceeds towards satisfaction of such liability.</p>
                        <p class="sub-heading" style="margin-top: 10px;">The contract of carriage evidenced by this Bill of
                            Lading is between the shipper, consignee and/or over of the cargo and the owner or demise
                            charterers of the Vessel named herein to carry the cargo described above,</p>
                        <p class="sub-heading">carrior or baile of said shipment or under any responsibility with respect
                            thereto, all limitations af or exonerations from liability and all defences provided by law or
                            by the terms of the contract of carriage shall be available to such other</p>
                        <p class="sub-heading" style="margin-top: 10px;">All of he provisions written, printed or stamped on
                            either side hereof are part of this Bill of Lading Contract. In Witness Whereof, the master has
                            signed <span> #3 (THREE) ORIGINALS# </span> Bills of Lading of this tenor and date, one of which
                            being accomplished, the others will be void.</p>
                        <p class="sub-heading">Dated at <span> ##IssuedPlace## </span> this <span> ##SignedDay## </span> day of
                            <span> ##SignedMonth## </span> <span> ##SignedYear## </span></p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-6" style="margin-top: 50px;"></div>
                    <div class="col-6" style="margin-top: 50px;">
                        <hr style="background: #000;">
                        <p class="sub-heading" style="text-align: center;">As Agents for and on behalf the master</p>
                        <p class="sub-heading" style="text-align: center;">CAPT. SEO PAN GI</p>
                    </div>
                </div>
                <div class="row terms-page-break">
                    <div class="col-12" style="margin-top: 20px;">
                        <p class="sub-heading" style="font-weight: bolder;">BILL OF LANDING</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12" style="margin-top: 5px;">
                        <p class="sub-heading">TO BE USED WITH CHARTER-PARTIES</p>
                    </div>
                </div>
                <div class="row">
                    <div style="width:38%"></div>
                    <div class="col-6">
                        <p class="sub-heading">Conditions of Carriage</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <p class="sub-heading">
                        <h5>(1) Ceneral Paramount Clause</h5>
                        </p>
                        <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(a) The Hague Rules contained
                            in the International Convention for the Unification of certain rules relating to Bills of
                            Landing, dated Brussels the 25% August 1924 as enncted in the country of shipment, shall apply
                            to this Bill of Landing When no such enactment is in force the country of shipment. the
                            corresponding legislation of the country of destination shall apply, but in respect of shipments
                            to which no such enactments are compulsorily applicable, the terms of the said Convention shall
                            apply.</p>
                        <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(b) Trades where Hauge-Visby
                            Rules apply. In trades where the International Brussels Convention 1924 as amended by the
                            Protocol signed at Brussels on February 23 196&- the Hague-Visby Rules-apply compulsorily, the
                            provisions of the respective legislation shall apply to this Bill of Landing</p>
                        <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(c) The Carrier shall in no
                            case be responsible for the loss of or damage to the cargo, howsoever arising prior to loading
                            into and affer discharge from the Vessel or while the cargo is in the charge of another Carrier,
                            nor in respect of deck cargo or live animals.</p>
                        <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(d) If the carriage covered
                            by this Bill of Landing includes Carriage to or from a port or place in the United States of
                            America, this Bill of Landing shall be subject to the United States Carriage of Goods by Sea Act
                            1939 (US COGS A), the terms of which are incorporated herein and shall govern throughout the
                            entire Carriage set forth in this Bill of Landing Neither the Hague or Hague-Visby Rules shall
                            apply to the Carriage to or from the United States. The Carrier shall be entitled to the
                            benefits of the defenses and limitations in US COGSA. whether the loss or damage to the Goods
                            occurs at sea or not.</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <p class="sub-heading">
                        <h5>(2) General Average</h5>
                        </p>
                        <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">General Average shall be
                            adjusted, stated and settled according to York-Antwerp Rules 1994, or any subsequent
                            modification thereof, in London unless another place is agreed in the Charter Party. Cargos
                            contribution to General Avcrage shall be paid to the Carrier even when such average is the
                            result of a fault, neglect or error of the Master, Pilot or Crew. The Charterers, Shippers,
                            Consignees and the Holder of this Bill of Landing expressly renounce the Belgian Commercial
                            Code, Part II. Art. 148,</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <p class="sub-heading">
                        <h5>(3) New Jason Clause</h5>
                        </p>
                        <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">In the event of accident,
                            danger, or disaster before or after the commencement of the voyage, resulting from any cause
                            whatsoever, whether due to negligence or not, for which or for the consequence of which, the
                            Carrier is not responsible, by statute, contract or otherwise, the cargo, Shippers, Cosignees,
                            the Owners of the cargo or the Holder of this Bill of Landing shall contribute with the Carrier
                            in General Average to the payment of any sacrifices, losses or expenses of a General Average
                            nature that may be made or incurred and shall pay salvage and special charges incurred in
                            respect of the cargo. If a salving vessel, is owned or operated by the Carrier, salvage shall be
                            paid for as fully as if the said salving vessel or vessels belonged to strangers. Such deposit
                            as the Carrier, or his agents, may deem suflicient to cover the estimated contribution of the
                            goods and any salvage and special charges thereon shall, if required, be made by the cargo,
                            Shippers, Consignces or Owners of the goods or Holder of this Bill of Landing to the Carrier
                            before delivery.</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <p class="sub-heading">
                        <h5>(4) Both-to-Blame Collision Clause</h5>
                        </p>
                        <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">If the Vessel comes into
                            collision with another vessel as a result of the negligence of the other vessel and any act,
                            neglect or default of the Master, Mariner. Pilot or the servants of the Carrier in the
                            navigation or in the management of the Vessel, the owners of the cargo carried hereunder and the
                            Holder of this Bill of Landing will indemnify the Carrier against all loss of liability to the
                            other or non-carrying vessel or her owners in so far as such loss or liability represents loss
                            of, or damage to, or any claim whatsoever of the owners of said cargo, paid or payable by the
                            vessel or her owners as part of their claim against the carrying Vessel or the Carrier. The
                            foregoing provisions shall also apply where the owners, operators or those in charge of any
                            vessel or vessels or objects other than, or in addition to, the colliding vessels or objects are
                            at fault in respect of a collision or contact.</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <p class="sub-heading">
                        <h5>(5) Notice of Loss or Damage to the Goods</h5>
                        </p>
                        <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">Unless Notice of Loss or
                            Damage to the Goods and the general nature of such loss or damage be given in writing to the
                            Carrier or his agent at the port of discharge before or at the time of the removal of the goods
                            into the custody of the person entitled to delivery thereof under the contract of carriage, or,
                            if the loss or damage be not apparent within 3 (three) days, such removal shall be prima facie
                            evidence of the delivary by the carrier of the goods as described in the bill or landing
                            (Hague-Visby Rules Article Ill Rule 6)</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <p class="sub-heading">
                        <h5>(6) Time Bar</h5>
                        </p>
                        <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">All liability whatsoever of
                            the Carrier shall cease unless suit is brought within 1 (one) year after delivery of the goods
                            or the date when the goods should have been delivered,</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <p class="sub-heading">
                        <h5>(7) Cargo loss</h5>
                        </p>
                        <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">The Carrier shall not be
                            liabla for any short outturn cargo quantity below 0.5% as determined by the discrepancy between
                            the quantity of cargo received onboard the vessel in Port of Loading and the ships ligure in
                            Port of Discharge</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <p class="sub-heading">
                        <h5>(8) Limitation of Liability</h5>
                        </p>
                        <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">The Carrier shall have the
                            benefit of all applicable imitations of an exemptions from liability accorded to the Carrier by
                            any laws, statues, or regulations of any country for the time being in force notwithstanding any
                            provision of the charterparty</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <p class="sub-heading">
                        <h5>(9) Himalaya Cargo Clause</h5>
                        </p>
                        <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">It is hereby expressly agreed
                            that no servant or agent of the Carrier (including every independent contractor from time to
                            time employed by the Carrier) shall in any circumstances whatsoever be under any liability to
                            the shipper. Consignce or owner of the cargo or to any Holder of this Bill of Landing for any
                            loss, damage or delay of whatsoever kind arising or resulting directly or indirectly from any
                            act, neglect or default on his part while acting in the course of or in connection with his
                            employment and, but without prejudice to generality of the foregoing provisions in this Clause,
                            every exemption, limitation, condition and liberty herein contained and every right, exemption
                            from liability, defense and immunity of whatsoever nature applicable to the Carrier or to which
                            the Carrier is entitled hereunder shall also be available and shall extend to protect every such
                            servant pr agent of the Carrior acting as aforesaid and for the purpose of all the foregoing
                            provisions of the Clause the Carrier is or shall be deemed to be acting as agent or trustee on
                            behalf of and for the benefit of all persons who are or might be his servants or agent from time
                            to time (including independent contractions as aforesaid) and all such-persons shall to this
                            extent be or be deemed to be parties to the contract in or evidenced by this Bill of Landing The
                            Carrier shall be entitled to be paid by the Shipper. Consignee, owner of the cargo and or Holder
                            of the Bill of Landing (who shall be jointly and severally liable to the carrier therefore) on
                            demand any sum recovered or recoverable by either such Shipper, Consignes, owner of the cargo
                            and or Holder of the Bill of Landing or any other from such servant or agent of the Carrier for
                            any such loss, damage, delay or otherwise.</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12" style="margin-top: 10px;">
                        <p class="sub-heading">All terms and conditions, liberties and exceptions of the BIMCO War Risk
                            Clause for Time Charters,</p>
                        <p class="sub-heading">2004 (Codename: Conwartime 2004) and amendments thereto are herewith
                            incorporated.</p>
                    </div>
                </div>
            </div>
        </div>
    </body>
    
    </html>' where EmailTemplateName='BLDraftPurchaseTemplate' AND CompanyId =  @CompanyId


update emailtemplates set EmailTemplate = '<!DOCTYPE html>
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

        h1,h2,h3,h4,h5,h6{
            margin: 0;
            padding: 0;
        }
        p{
            margin: 0;
            padding: 0;
        }
        .container{
            width: 95%;
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
        .sub-heading{
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
</html>' where EmailTemplateName='CertificateOfOriginPdfTemplate' AND CompanyId =  @CompanyId

update EmailTemplates set EmailTemplate='<!DOCTYPE html>
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
        h1,h2,h3,h4,h5,h6{
            margin: 0;
            padding: 0;
        }
        p{
            margin: 0;
            padding: 0;
        }
        .container{
            width: 95%;
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
        .sub-heading{
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
</html>' where EmailTemplateName = 'FreightCertificatePdfTemplate' AND CompanyId =  @CompanyId

update EmailTemplates set emailtemplate ='<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>MGV COMMODITY PTE LTD</title>
    <style>
        body {
            background-color: #f6f6f6;
            margin: 0;
            padding: 0;
            font-family: Verdana, Geneva, sans-serif;
            font-style: normal;
            font-variant: normal
        }
        
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


        h1,
        h2,
        h3,
        h4,
        h5,
        h6 {
            margin: 0;
            padding: 0
        }

        p {
            margin: 0;
            padding: 0
        }

        .container {
            width: 95%;
            margin-right: auto;
            margin-left: auto
        }

        .row {
            display: flex;
            flex-wrap: wrap
        }

        .col-6 {
            width: 50%;
            flex: 0 0 auto
        }

        .col-4 {
            width: 30%;
            flex: 0 0 auto
        }

        .col-3 {
            width: 23%;
            flex: 0 0 auto
        }

        .col-8 {
            width: 74%;
            flex: 0 0 auto
        }

        .col-12 {
            width: 100%;
            flex: 0 0 auto
        }


        .sub-heading {
            color: #262626
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
                    <p class="sub-heading" style="text-align:center;color:red;font-size:40px">MGV COMMODITY PTE LTD</p>
                    <p class="sub-heading" style="text-align:center;font-weight:600">77 HIGH STREET #4-11 HIGH STREET
                        PLAZA, SINGAPORE 179433</p>
                    <p class="sub-heading" style="text-align:center">Registration No. 201618435E PHONE +65-63362665</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading"
                        style="font-weight:600;text-decoration:underline;text-align:center;font-size:16px">COMMERCIAL
                        INVOICE</p>
                </div>
            </div>
            <div class="row">
                <div class="col-6" style="margin-top:10px">
                    <p class="sub-heading" style="font-weight:600;font-size:14px">No : ##InvoiceNumber##</p>
                </div>
                <div class="col-6" style="margin-top:10px">
                    <p class="sub-heading" style="font-weight:600;float:right;font-size:14px">Date : ##IssueDate##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:5px">
                    <p class="sub-heading" style="font-weight:600;font-size:14px">BUYER:</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:5px">
                    <p class="sub-heading" style="font-weight:600;font-size:14px">##SellerName##</p>
                    <p class="sub-heading" style="font-weight:600;font-size:14px">##SellerAddressLine1##</p>
                    <p class="sub-heading" style="font-weight:600;font-size:14px">##SellerAddressLine2##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <hr style="background:#000">
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <table>
                        <tr>
                            <td style="padding-bottom:10px;font-size:14px">PORT OF LOADING</td>
                            <td style="padding-bottom:10px;font-size:14px">: ##PortLoad##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom:10px;font-size:14px">PORT OF DISCHARGE</td>
                            <td style="padding-bottom:10px;font-size:14px">: ##PortDischarge##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom:10px;font-size:14px">B/L NO. & DATE<br><br></td>
                            <td style="padding-bottom:10px;font-size:14px">: ##BLNoAndDate##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom:10px;font-size:14px">NAME OF VESSEL</td>
                            <td style="padding-bottom:10px;font-size:14px">: ##VesselName##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom:10px;font-size:14px">PAYMENT TERMS</td>
                            <td style="padding-bottom:10px;font-size:14px">: ##PaymentTerms##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom:10px;font-size:14px">DRAWEE''S BANK</td>
                            <td style="padding-bottom:10px;font-size:14px">: ##DraweesBank##</td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <hr style="background:#000">
                </div>
            </div>
            <div class="row">
                <div class="col-4" style="font-size:14px;text-align:center;font-weight:600">
                    <p class="sub-heading">DESCRIPTION OF GOODS</p>
                </div>
                <div class="col-3" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">QUANTITY MT</p>
                </div>
                <div class="col-3" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">UNIT PRICE (USD)<br>CFR HALDIA, INDIA</p>
                </div>
                <div class="col-3" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">AMOUNT (USD)</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <hr style="background:#000">
                </div>
            </div>
            <div class="row">
                <div class="col-4" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">CRUDE PALM OIL (EDIBLE GRADE) IN BULK</p>
                </div>
                <div class="col-3" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">##Quantity##</p>
                </div>
                <div class="col-3" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">##UnitPrice##</p>
                </div>
                <div class="col-3" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">##Amount##</p>
                </div>
            </div>
        </div>
        <div class="row" style="margin-top:20px">
            <div class="col-4" style="font-size:14px;font-weight:600">
                <p class="sub-heading" style="text-align:center">TOTAL QTY</p>
            </div>
            <div class="col-3" style="font-size:14px;font-weight:600">
                <p class="sub-heading" style="border-top-style:dotted;border-bottom-style:dotted;padding:10px">
                    ##Quantity##</p>
            </div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
        </div>
        <div class="row" style="margin-top:20px">
            <div class="col-4">
                <p class="sub-heading" style="font-weight:600;font-size:13px">WE CERTIFY:</p>
                <p class="sub-heading" style="font-size:12px">A) THAT IMPORT IS NOT UNDER NEGATIVE LIST AND FREELY
                    IMPORTABLE AS PER INDIA''S FOREGIN TRADE POLICY 2022</p>
                <p class="sub-heading" style="font-size:12px;margin-top:10px">B) THAT THE OIL IS FREE FROM
                    CONMTAMINATION AND SEA WATER AT THE TIME OF SHIPMENT AND THIS CONSIGNMENT DOES NOT CONTAIN BEEF IN
                    ANY FORM</p>
                <p class="sub-heading" style="font-size:12px;margin-top:10px">C) THAT THE FREIGHT CHARGED FOR THIS
                    SHIPMENT IS USD 50 PER MT</p>
                <p class="sub-heading" style="font-size:12px;margin-top:10px">D) THE GOODS ARE OF PAPUA NEW GUINEA
                    ORIGIN</p>
                <p class="sub-heading" style="font-size:12px;margin-top:60px;font-weight:600">QUALITY SPECIFICATION</p>
                <p class="sub-heading" style="font-size:12px;margin-top:10px;text-decoration:underline;font-weight:600">
                    TERMS</p>
                <p class="sub-heading" style="font-size:12px;margin-top:10px">FFA 4.5% MAX</p>
                <p class="sub-heading" style="font-size:12px;margin-top:10px">MN 0.5% MAX</p>
            </div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
        </div>
        <div class="row" style="margin-top:20px">
            <div class="col-4" style="font-size:14px;font-weight:600">
                <p class="sub-heading">TOTAL INVOICE VALUE US$</p>
            </div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
            <div class="col-3" style="font-size:14px;font-weight:600">
                <p class="sub-heading" style="border-top-style:dotted;border-bottom-style:dotted;padding:10px">
                    ##Amount##</p>
            </div>
        </div>
        <div class="row">
            <div class="col-12" style="margin-top:10px">
                <p class="sub-heading" style="font-weight:600;font-size:12px">(US DOLLARS ELEVEN MILLION TWENTY SEVEN
                    THOUSAND SIX HUNDERED SEVENTY AND CENT SIXTY THREE ONLY)</p>
                <hr style="background:#000">
                <p class="sub-heading" style="font-size:12px;font-weight:600">Payment by Telegraphic Transfer to our
                    account as under:</p>
            </div>
        </div>
        <div class="row">
            <div class="col-12">
                <table>
                    <tr>
                        <td style="padding-bottom:10px;font-size:14px">Bank Name</td>
                        <td style="padding-bottom:10px;font-size:14px">: HSBC LIMITED, 9 Battery Road #12-01 MYP Centre,
                            SINGAPORE 049910</td>
                    </tr>
                    <tr>
                        <td style="padding-bottom:10px;font-size:14px">Swift Code</td>
                        <td style="padding-bottom:10px;font-size:14px">: HSBCSGSG</td>
                    </tr>
                    <tr>
                        <td style="padding-bottom:10px;font-size:14px">Branch Code</td>
                        <td style="padding-bottom:10px;font-size:14px">: 7232</td>
                    </tr>
                    <tr>
                        <td style="padding-bottom:10px;font-size:14px">Account Name</td>
                        <td style="padding-bottom:10px;font-size:14px">: MGV COMMODITY PTE LTD</td>
                    </tr>
                    <tr>
                        <td style="padding-bottom:10px;font-size:14px">Accont Number(USD)</td>
                        <td style="padding-bottom:10px;font-size:14px;font-weight:600">: 25637373889</td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="row">
            <div class="col-12" style="margin-top:10px">
                <p class="sub-heading" style="font-weight:600;font-style:italic">Please Quote Invoice number in the
                    description filed of the remittance</p>
                <hr style="background:#000">
            </div>
        </div>
        <div class="row">
            <div class="col-12">
                <p class="sub-heading" style="font-weight:600;font-size:16px">MGV COMMODITIY PTE LTD</p>
            </div>
        </div>
        <div class="row">
            <div class="col-12" style="margin-top:70px">
                <p class="sub-heading" style="font-weight:600;font-size:14px">AUTHORISED SIGNATORY</p>
            </div>
        </div>
    </div>
</body>

</html>' where emailtemplatename='InvoiceFromSellerStepEmailTemplate' AND CompanyId =  @CompanyId


update EmailTemplates set emailtemplate ='<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>MGV COMMODITY PTE LTD</title>
    <style>
        body {
            background-color: #f6f6f6;
            margin: 0;
            padding: 0;
            font-family: Verdana, Geneva, sans-serif;
            font-style: normal;
            font-variant: normal
        }
        
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

        h1,
        h2,
        h3,
        h4,
        h5,
        h6 {
            margin: 0;
            padding: 0
        }

        p {
            margin: 0;
            padding: 0
        }

        .container {
            width: 95%;
            margin-right: auto;
            margin-left: auto
        }

        .row {
            display: flex;
            flex-wrap: wrap
        }

        .col-6 {
            width: 50%;
            flex: 0 0 auto
        }

        .col-4 {
            width: 30%;
            flex: 0 0 auto
        }

        .col-3 {
            width: 23%;
            flex: 0 0 auto
        }

        .col-8 {
            width: 74%;
            flex: 0 0 auto
        }

        .col-12 {
            width: 100%;
            flex: 0 0 auto
        }


        .sub-heading {
            color: #262626
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
                    <p class="sub-heading" style="text-align:center;color:red;font-size:40px">MGV COMMODITY PTE LTD</p>
                    <p class="sub-heading" style="text-align:center;font-weight:600">77 HIGH STREET #4-11 HIGH STREET
                        PLAZA, SINGAPORE 179433</p>
                    <p class="sub-heading" style="text-align:center">Registration No. 201618435E PHONE +65-63362665</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading"
                        style="font-weight:600;text-decoration:underline;text-align:center;font-size:16px">COMMERCIAL
                        INVOICE</p>
                </div>
            </div>
            <div class="row">
                <div class="col-6" style="margin-top:10px">
                    <p class="sub-heading" style="font-weight:600;font-size:14px">No : ##InvoiceNumber##</p>
                </div>
                <div class="col-6" style="margin-top:10px">
                    <p class="sub-heading" style="font-weight:600;float:right;font-size:14px">Date : ##IssueDate##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:5px">
                    <p class="sub-heading" style="font-weight:600;font-size:14px">BUYER:</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:5px">
                    <p class="sub-heading" style="font-weight:600;font-size:14px">##BuyerName##</p>
                    <p class="sub-heading" style="font-weight:600;font-size:14px">##BuyerAddressLine1##</p>
                    <p class="sub-heading" style="font-weight:600;font-size:14px">##BuyerAddressLine2##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <hr style="background:#000">
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <table>
                        <tr>
                            <td style="padding-bottom:10px;font-size:14px">PORT OF LOADING</td>
                            <td style="padding-bottom:10px;font-size:14px">: ##PortLoad##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom:10px;font-size:14px">PORT OF DISCHARGE</td>
                            <td style="padding-bottom:10px;font-size:14px">: ##PortDischarge##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom:10px;font-size:14px">B/L NO. & DATE<br><br></td>
                            <td style="padding-bottom:10px;font-size:14px">: ##BLNoAndDate##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom:10px;font-size:14px">NAME OF VESSEL</td>
                            <td style="padding-bottom:10px;font-size:14px">: ##VesselName##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom:10px;font-size:14px">PAYMENT TERMS</td>
                            <td style="padding-bottom:10px;font-size:14px">: ##PaymentTerms##</td>
                        </tr>
                        <tr>
                            <td style="padding-bottom:10px;font-size:14px">DRAWEE''S BANK</td>
                            <td style="padding-bottom:10px;font-size:14px">: ##DraweesBank##</td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <hr style="background:#000">
                </div>
            </div>
            <div class="row">
                <div class="col-4" style="font-size:14px;text-align:center;font-weight:600">
                    <p class="sub-heading">DESCRIPTION OF GOODS</p>
                </div>
                <div class="col-3" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">QUANTITY MT</p>
                </div>
                <div class="col-3" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">UNIT PRICE (USD)<br>CFR HALDIA, INDIA</p>
                </div>
                <div class="col-3" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">AMOUNT (USD)</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <hr style="background:#000">
                </div>
            </div>
            <div class="row">
                <div class="col-4" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">CRUDE PALM OIL (EDIBLE GRADE) IN BULK</p>
                </div>
                <div class="col-3" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">##Quantity##</p>
                </div>
                <div class="col-3" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">##UnitPrice##</p>
                </div>
                <div class="col-3" style="font-size:14px;font-weight:600">
                    <p class="sub-heading">##Amount##</p>
                </div>
            </div>
        </div>
        <div class="row" style="margin-top:20px">
            <div class="col-4" style="font-size:14px;font-weight:600">
                <p class="sub-heading" style="text-align:center">TOTAL QTY</p>
            </div>
            <div class="col-3" style="font-size:14px;font-weight:600">
                <p class="sub-heading" style="border-top-style:dotted;border-bottom-style:dotted;padding:10px">
                    ##Quantity##</p>
            </div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
        </div>
        <div class="row" style="margin-top:20px">
            <div class="col-4">
                <p class="sub-heading" style="font-weight:600;font-size:13px">WE CERTIFY:</p>
                <p class="sub-heading" style="font-size:12px">A) THAT IMPORT IS NOT UNDER NEGATIVE LIST AND FREELY
                    IMPORTABLE AS PER INDIA''S FOREGIN TRADE POLICY 2022</p>
                <p class="sub-heading" style="font-size:12px;margin-top:10px">B) THAT THE OIL IS FREE FROM
                    CONMTAMINATION AND SEA WATER AT THE TIME OF SHIPMENT AND THIS CONSIGNMENT DOES NOT CONTAIN BEEF IN
                    ANY FORM</p>
                <p class="sub-heading" style="font-size:12px;margin-top:10px">C) THAT THE FREIGHT CHARGED FOR THIS
                    SHIPMENT IS USD 50 PER MT</p>
                <p class="sub-heading" style="font-size:12px;margin-top:10px">D) THE GOODS ARE OF PAPUA NEW GUINEA
                    ORIGIN</p>
                <p class="sub-heading" style="font-size:12px;margin-top:60px;font-weight:600">QUALITY SPECIFICATION</p>
                <p class="sub-heading" style="font-size:12px;margin-top:10px;text-decoration:underline;font-weight:600">
                    TERMS</p>
                <p class="sub-heading" style="font-size:12px;margin-top:10px">FFA 4.5% MAX</p>
                <p class="sub-heading" style="font-size:12px;margin-top:10px">MN 0.5% MAX</p>
            </div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
        </div>
        <div class="row" style="margin-top:20px">
            <div class="col-4" style="font-size:14px;font-weight:600">
                <p class="sub-heading">TOTAL INVOICE VALUE US$</p>
            </div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
            <div class="col-3" style="font-size:14px;font-weight:600"></div>
            <div class="col-3" style="font-size:14px;font-weight:600">
                <p class="sub-heading" style="border-top-style:dotted;border-bottom-style:dotted;padding:10px">
                    ##Amount##</p>
            </div>
        </div>
        <div class="row">
            <div class="col-12" style="margin-top:10px">
                <p class="sub-heading" style="font-weight:600;font-size:12px">(US DOLLARS ELEVEN MILLION TWENTY SEVEN
                    THOUSAND SIX HUNDERED SEVENTY AND CENT SIXTY THREE ONLY)</p>
                <hr style="background:#000">
                <p class="sub-heading" style="font-size:12px;font-weight:600">Payment by Telegraphic Transfer to our
                    account as under:</p>
            </div>
        </div>
        <div class="row">
            <div class="col-12">
                <table>
                    <tr>
                        <td style="padding-bottom:10px;font-size:14px">Bank Name</td>
                        <td style="padding-bottom:10px;font-size:14px">: HSBC LIMITED, 9 Battery Road #12-01 MYP Centre,
                            SINGAPORE 049910</td>
                    </tr>
                    <tr>
                        <td style="padding-bottom:10px;font-size:14px">Swift Code</td>
                        <td style="padding-bottom:10px;font-size:14px">: HSBCSGSG</td>
                    </tr>
                    <tr>
                        <td style="padding-bottom:10px;font-size:14px">Branch Code</td>
                        <td style="padding-bottom:10px;font-size:14px">: 7232</td>
                    </tr>
                    <tr>
                        <td style="padding-bottom:10px;font-size:14px">Account Name</td>
                        <td style="padding-bottom:10px;font-size:14px">: MGV COMMODITY PTE LTD</td>
                    </tr>
                    <tr>
                        <td style="padding-bottom:10px;font-size:14px">Accont Number(USD)</td>
                        <td style="padding-bottom:10px;font-size:14px;font-weight:600">: 25637373889</td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="row">
            <div class="col-12" style="margin-top:10px">
                <p class="sub-heading" style="font-weight:600;font-style:italic">Please Quote Invoice number in the
                    description filed of the remittance</p>
                <hr style="background:#000">
            </div>
        </div>
        <div class="row">
            <div class="col-12">
                <p class="sub-heading" style="font-weight:600;font-size:16px">MGV COMMODITIY PTE LTD</p>
            </div>
        </div>
        <div class="row">
            <div class="col-12" style="margin-top:70px">
                <p class="sub-heading" style="font-weight:600;font-size:14px">AUTHORISED SIGNATORY</p>
            </div>
        </div>
    </div>
</body>

</html>' where emailtemplatename='InvoiceToBuyerStepEmailTemplate' AND CompanyId =  @CompanyId


update EmailTemplates set EmailTemplate='<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>LOT Switching BL</title>
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
            background-color: #f6f6f6;
            margin: 0;
            padding: 0;
            font-family: Verdana, Geneva, sans-serif;
            font-style: normal;
            font-variant: normal
        }

        h1,
        h2,
        h3,
        h4,
        h5,
        h6 {
            margin: 0;
            padding: 0
        }

        p {
            margin: 0;
            padding: 0
        }

        .container {
            width: 95%;
            margin-right: auto;
            margin-left: auto
        }

        .row {
            display: flex;
            flex-wrap: wrap
        }

        .col-6 {
            width: 50%;
            flex: 0 0 auto
        }

        .col-4 {
            width: 33%;
            flex: 0 0 auto
        }

        .col-8 {
            width: 74%;
            flex: 0 0 auto
        }

        .col-3 {
            width: 20%;
            flex: 0 0 auto
        }

        .col-9 {
            width: 80%;
            flex: 0 0 auto
        }

        .col-12 {
            width: 100%;
            flex: 0 0 auto
        }

        .sub-heading {
            color: #262626;
            margin-bottom: 5px;
            font-size: 14px
        }

        span {
            color: #00f
        }

        .col-1 {
            width: 10%;
            flex: 0 0 auto
        }

        .col-custom-4 {
            width: 53%;
            flex: 0 0 auto
        }
    </style>
</head>

<body>
    <div class="container">
    <div id="pageborder">
        </div>
        <div class="body-section">
            <div class="row">
                <div class="col-12" style="margin-top:30px">
                    <p class="sub-heading" style="font-weight:600;font-size:18px;text-decoration:underline">STANDARD
                        FORM LETTER OF INDEMNITY TO BE GIVEN IN RETURN FOR SWITCHING BILL OF LADING</p>
                </div>
            </div>
            <div class="row">
                <div class="col-1" style="margin-top:20px">
                    <p class="sub-heading">To:</p>
                </div>
                <div class="col-custom-4" style="margin-top:20px">
                    <p class="sub-heading">##ToAddress##</p>
                </div>
                <div class="col-4" style="margin-top:20px">
                    <p class="sub-heading">##ToDate##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading">Dear Sirs</p>
                </div>
            </div>
            <div class="row">
                <div class="col-3">
                    <p class="sub-heading" style="margin-bottom:15px">Description</p>
                </div>
                <div class="col-9">
                    <p class="sub-heading" style="margin-bottom:15px">: ##1stDescription##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">1st set B/L description</p>
                </div>
            </div>
            <div class="row">
                <div class="col-3">
                    <p class="sub-heading" style="margin-bottom:15px">1) Shipper</p>
                    <p class="sub-heading" style="margin-bottom:15px">Consignee</p>
                    <p class="sub-heading" style="margin-bottom:15px">Notify party</p>
                    <p class="sub-heading" style="margin-bottom:15px">Loadport</p>
                    <p class="sub-heading" style="margin-bottom:15px">Disport</p>
                    <p class="sub-heading" style="margin-bottom:15px;color:red">B/L NO</p>
                    <p class="sub-heading" style="margin-bottom:15px">B/L Date</p>
                    <p class="sub-heading" style="margin-bottom:15px">B/L Quantity</p>
                </div>
                <div class="col-9">
                    <p class="sub-heading" style="margin-bottom:15px">: ##Shipper1##</p>
                    <p class="sub-heading" style="margin-bottom:15px">: ##Consignee1##</p>
                    <p class="sub-heading" style="margin-bottom:15px">: ##NotifyPrty1##</p>
                    <p class="sub-heading" style="margin-bottom:15px">: ##LoadPort1##</p>
                    <p class="sub-heading" style="margin-bottom:15px">: ##DischargePort1##</p>
                    <p class="sub-heading" style="margin-bottom:15px;color:red">: ##BLNO1##</p>
                    <p class="sub-heading" style="margin-bottom:15px">: ##BLDate1##</p>
                    <p class="sub-heading" style="margin-bottom:15px">: ##BLQuantity1##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">The above cargo was shipped on the above ship by ##ShipBy1## and consigned to
                        ##ConsignedTo1## for delivery at the port of ##PortOfDelivery1##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading">We, ##HereByName##, hereby request you to change the Bill of Lading at the
                        loading port with new set as per our above instruction via ##SwitchBlAgent## in ##Country## AS
                        AT ##PortOfLoading1##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-3" style="margin-top:30px">
                    <p class="sub-heading" style="margin-bottom:15px">Description</p>
                </div>
                <div class="col-9" style="margin-top:30px">
                    <p class="sub-heading" style="margin-bottom:15px">: ##2ndDescription##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">2nd set B/L description</p>
                </div>
            </div>
            <div class="row">
                <div class="col-3">
                    <p class="sub-heading" style="margin-bottom:15px">2) Shipper</p>
                    <p class="sub-heading" style="margin-bottom:15px">Consignee</p>
                    <p class="sub-heading" style="margin-bottom:15px">Notify party</p>
                    <p class="sub-heading" style="margin-bottom:15px">Loadport</p>
                    <p class="sub-heading" style="margin-bottom:15px">Disport</p>
                    <p class="sub-heading" style="margin-bottom:15px;color:red">B/L NO</p>
                    <p class="sub-heading" style="margin-bottom:15px">B/L Date</p>
                    <p class="sub-heading" style="margin-bottom:15px">B/L Quantity</p>
                </div>
                <div class="col-9">
                    <p class="sub-heading" style="margin-bottom:15px">: ##Shipper2##</p>
                    <p class="sub-heading" style="margin-bottom:15px">: ##Consignee2##</p>
                    <p class="sub-heading" style="margin-bottom:15px">: ##NotifyPrty2##</p>
                    <p class="sub-heading" style="margin-bottom:15px">: ##LoadPort2##</p>
                    <p class="sub-heading" style="margin-bottom:15px">: ##DischargePort2##</p>
                    <p class="sub-heading" style="margin-bottom:15px;color:red">: ##BLNO2##</p>
                    <p class="sub-heading" style="margin-bottom:15px">: ##BLDate2##</p>
                    <p class="sub-heading" style="margin-bottom:15px">: ##BLQuantity2##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">The above cargo was shipped on the above ship by ##ShipBy2## and consigned to
                        ##ConsignedTo2## for delivery at the port of ##PortOfDelivery2##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading">We, ##HereByName##, hereby request you to change the Bill of Lading at the
                        loading port with new set as per our above instruction via ##SwitchBlAgent## in ##Country## AS
                        AT ##PortOfLoading2##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading">In consideration of your complying with our above request, we hereby agree as
                        follows:</p>
                    <p class="sub-heading">1. To indemnify you, your servants and agents and to hold all of you harmless
                        in respect of any liability, loss, damage or expense of whatsoever nature which you may sustain
                        by reason of the changing bills of lading and delivering the cargo in accordance with our
                        request</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading">2. In the event of any proceedings being commenced against you or any of your
                        servants or agents in connection with the delivery of the cargo as aforesaid to provide you or
                        them on demand with sufficient funds to defend the same</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading">3. If, in connection with the delivery of the cargo as aforesaid, the ship or
                        any other ship or property belonging to you in the same or associated ownership, management or
                        control, should be arrested or detained or should the arrest or detention thereof be threatened,
                        or should there be any interference in the use or trading of the vessel (whether by virtue of a
                        caveat being entered on the ship’s registry or otherwise howsoever), to provide on demand such
                        bail or other security as may be required to prevent such arrest or detention or to secure the
                        release of such ship or property or to remove such interference and to indemnify you in respect
                        of any liability, loss, damage or expense caused by such arrest or detention or threatened
                        arrest or detention or such interference, whether or not such arrest or detention or threatened
                        arrest or detention or such interference may be justified.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading">4. If the place at which we have asked you to make delivery is a bulk liquid
                        or gas terminal or facility, or another ship, lighter or barge, then delivery to such terminal,
                        facility, ship. Lighter or barge shall be deemed to be delivery to the party to whom we have
                        requested you to make such delivery.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading">5. As soon as all original Bills of Lading for the above cargo shall have
                        come into our possession, to deliver the same to you, or otherwise to cause all original Bills
                        of Lading to be delivered to you, whereupon our liability hereunder shall cease.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading">6. The liability of each and every person under this indemnity shall be joint
                        and several and shall not be conditional upon your proceeding first against any person, whether
                        or not such person is party to or liable under this indemnity.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading">7. This indemnity shall be governed by and construed in accordance with
                        [English] law and each and every person liable under this indemnity shall at your request submit
                        to the jurisdiction of the High Court of Justice of [London]</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading">Yours faithfully,</p>
                    <p class="sub-heading">For and on behalf of</p>
                    <p class="sub-heading" style="font-style:italic">##BehalfCompanyName##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading">.......................................</p>
                    <p class="sub-heading">##Signature##</p>
                </div>
            </div>
        </div>
    </div>
</body>

</html>' where EmailTemplateName = 'LOIBLPdfTemplate' AND CompanyId =  @CompanyId



update EmailTemplates set EmailTemplate='<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>LOI For Discharging Cargo</title>
    <style>
        body {
            background-color: #f6f6f6;
            margin: 0;
            padding: 0;
            font-family: Verdana, Geneva, sans-serif;
            font-style: normal;
            font-variant: normal
        }
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

        h1,
        h2,
        h3,
        h4,
        h5,
        h6 {
            margin: 0;
            padding: 0
        }

        p {
            margin: 0;
            padding: 0
        }

        .container {
            width: 95%;
            margin-right: auto;
            margin-left: auto
        }

        .row {
            display: flex;
            flex-wrap: wrap
        }

        .col-6 {
            width: 50%;
            flex: 0 0 auto
        }

        .col-4 {
            width: 25%;
            flex: 0 0 auto
        }

        .col-8 {
            width: 74%;
            flex: 0 0 auto
        }

        .col-3 {
            width: 20%;
            flex: 0 0 auto
        }

        .col-9 {
            width: 80%;
            flex: 0 0 auto
        }

        .col-12 {
            width: 100%;
            flex: 0 0 auto
        }

        .sub-heading {
            color: #262626;
            margin-bottom: 5px
        }

        span {
            color: #00f
        }
    </style>
</head>

<body>
    <div class="container">
    <div id="pageborder">
        </div>
        <div class="body-section">
            <div class="row">
                <div class="col-12" style="margin-top:30px">
                    <p class="sub-heading" style="font-weight:600;font-size:22px;font-family:''DM Serif Display'',serif">
                        INT GROUP A</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:30px">
                    <p class="sub-heading" style="font-weight:600">Standard form Letter of Indemnity to be given in
                        return for delivering cargo without production of the original Bill of Lading</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:40px">
                    <p class="sub-heading" style="text-align:center;font-style:italic">##Date##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:40px">
                    <p class="sub-heading">Dear Sirs</p>
                </div>
            </div>
            <div class="row">
                <div class="col-3" style="margin-top:30px">
                    <p class="sub-heading" style="margin-bottom:15px">AA.Ship :</p>
                    <p class="sub-heading" style="margin-bottom:15px">Voyage :</p>
                    <p class="sub-heading" style="margin-bottom:15px">Cargo :</p>
                    <p class="sub-heading" style="margin-bottom:15px">Bill of lading :</p>
                    <p class="sub-heading" style="margin-bottom:15px">BB.Ship :</p>
                    <p class="sub-heading" style="margin-bottom:15px">Voyage :</p>
                    <p class="sub-heading" style="margin-bottom:15px">Cargo :</p>
                    <p class="sub-heading" style="margin-bottom:15px">Bill of lading :</p>
                    <p class="sub-heading" style="margin-bottom:15px">CC.Ship :</p>
                    <p class="sub-heading" style="margin-bottom:15px">Voyage :</p>
                    <p class="sub-heading" style="margin-bottom:15px">Cargo :</p>
                    <p class="sub-heading" style="margin-bottom:15px">Bill of lading :</p>
                </div>
                <div class="col-9" style="margin-top:30px">
                    <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Ship##</p>
                    <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Voyage##</p>
                    <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Cargo##</p>
                    <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##BillOfLadingAAShip##</p>
                    <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Ship##</p>
                    <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Voyage##</p>
                    <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Cargo##</p>
                    <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##BillOfLadingBBShip##</p>
                    <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Ship##</p>
                    <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Voyage##</p>
                    <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##Cargo##</p>
                    <p class="sub-heading" style="font-style:italic;margin-bottom:15px">##BillOfLadingCCShip##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading" style="font-size:14px">The above cargo was shipped on the above ship
                        by<span>##ShippedBy##</span>and consigned to<span>##ConsignedTo##</span>for delivery at the port
                        of<span>##PortOfDelivery##</span>but the bill of lading has not arrived and we, ##HereByName##,
                        hereby request you to deliver the said cargo
                        to<span>##CargoTo##</span>at<span>##PortofDischarge##</span>without production of the original
                        bill of lading.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:10px">
                    <p class="sub-heading" style="font-size:14px">In consideration of your complying with our above
                        request, we hereby agree as follows: -</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:10px">
                    <p class="sub-heading" style="font-size:14px">1. To indemnify you, your servants and agents and to
                        hold all of you harmless in respect of any liability, loss, damage or expense of whatsoever
                        nature which you may sustain by reason of delivering the cargo in accordance with our request
                    </p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:10px">
                    <p class="sub-heading" style="font-size:14px">2. In the event of any proceedings being commenced
                        against you or any of your servants or agents in connection with the delivery of the cargo as
                        aforesaid, to provide you or them on demand with sufficient funds to defend the same.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:10px">
                    <p class="sub-heading" style="font-size:14px">3. If, in connection with the delivery of the cargo as
                        aforesaid, the ship, or any other ship or property in the same or associated ownership,
                        management or control, should be arrested or detained or should the arrest or detention thereof
                        be threatened, or should there be any interference in the use or trading of the vessel (whether
                        by virtue of a caveat being entered on the ship’s registry or otherwise howsoever), to provide
                        on demand such bail or other security as may be required to prevent such arrest or detention or
                        to secure the release of such ship or property or to remove such interference and to indemnify
                        you in respect of any liability, loss, damage or expense caused by such arrest or detention or
                        threatened arrest or detention or such interference, whether or not such arrest or detention or
                        threatened arrest or detention or such interference may be justified.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:10px">
                    <p class="sub-heading" style="font-size:14px">1. To indemnify you, your servants and agents and to
                        hold all of you harmless in respect of any liability, loss, damage or expense of whatsoever
                        nature which you may sustain by reason of delivering the cargo in accordance with our request
                    </p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:10px">
                    <p class="sub-heading" style="font-size:14px">4. If the place at which we have asked you to make
                        delivery is a bulk liquid or gas terminal or facility, or another ship, lighter or barge, then
                        delivery to such terminal, facility, ship, lighter or barge shall be deemed to be delivery to
                        the party to whom we have requested you to make such delivery.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:10px">
                    <p class="sub-heading" style="font-size:14px">5. As soon as all original bills of lading for the
                        above cargo shall have come into our possession, to deliver the same to you, or otherwise to
                        cause all original bills of lading to be delivered to you, whereupon our liability hereunder
                        shall cease.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:10px">
                    <p class="sub-heading" style="font-size:14px">6. The liability of each and every person under this
                        indemnity shall be joint and several and shall not be conditional upon your proceeding first
                        against any person, whether or not such person is party to or liable under this indemnity.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:10px">
                    <p class="sub-heading" style="font-size:14px">7. This indemnity shall be governed by and construed
                        in accordance with English law and each and every person liable under this indemnity shall at
                        your request submit to the jurisdiction of the High Court of Justice of England.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:20px">
                    <p class="sub-heading" style="font-size:14px">Yours faithfully,</p>
                    <p class="sub-heading" style="font-size:14px">For and on behalf of</p>
                    <p class="sub-heading" style="font-size:14px"><span>##Requestor##</span></p>
                    <p class="sub-heading" style="font-size:14px">The Requestor</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top:50px">
                    <p class="sub-heading">.......................................</p>
                    <p class="sub-heading">##Signature##</p>
                </div>
            </div>
        </div>
    </div>
</body>

</html>' where EmailTemplateName = 'LOIOFDischargingCargoPortPdfTemplate' AND CompanyId =  @CompanyId


update EmailTemplates set EmailTemplate='<!DOCTYPE html>
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
        h1,h2,h3,h4,h5,h6{
            margin: 0;
            padding: 0;
        }
        p{
            margin: 0;
            padding: 0;
        }
        .container{
            width: 95%;
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
        .sub-heading{
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
</html>' where EmailTemplateName = 'ShelfLifeCertificatePdfTemplate' AND CompanyId =  @CompanyId


update emailtemplates set EmailTemplate = '<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>INVOICE</title>
    <style>
        #pageborder {
            position: fixed;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            border: 2px solid black;
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

        @media print {
            .terms-page-break {
                page-break-before: always;
            }
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

        .brand-section {
            background-color: #0d1033;
            padding: 10px 40px;
        }

        .row {
            display: flex;
            flex-wrap: wrap;
        }

        .col-6 {
            width: 50%;
            flex: 0 0 auto;
        }

        .text-white {
            color: #fff;
        }

        .company-details {
            float: right;
            text-align: right;
        }



        .heading {
            font-size: 20px;
            margin-bottom: 08px;
        }

        .sub-heading {
            color: #262626;
            margin-bottom: 05px;
        }

        .w-20 {
            width: 20%;
        }

        .float-right {
            float: right;
        }

        span {
            text-decoration: underline;
            color: blue;
        }
    </style>
</head>

<body>
    <div class="container">
        <div id="pageborder">
        </div>
        <div class="body-section">
            <div class="row">
                <div class="col-6">
                    <p style="margin-top:10px">Shipped in apparent good order and condition by</p>
                    <hr style="background: blue;">
                    <p class="sub-heading">Shipper</p>
                </div>
                <div class="col-6">
                    <p class="sub-heading"
                        style="margin-left: 50px; font-size: 26px; font-weight: bolder;margin-top:10px">Tanker Bill
                        of Landing</p>
                    <p class="sub-heading" style="margin-left: 50px; font-weight: bolder;">B/L NO. CY/DMI/HAL-02</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">##Shipper##</p>
                    <hr style="background: blue;">
                    <p class="sub-heading">Consignee/Order of</p>
                </div>
            </div>
            <div class="row">
                <div class="col-6">
                    <p class="sub-heading">TO ORDER</p> <br>
                    <hr style="background: blue;">
                    <p class="sub-heading">Notify Address</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">##NotifyAddress##</p>
                </div>
            </div>
            <div class="col-12">
                <hr style="background: blue;">
            </div>
            <div class="row">
                <div class="col-4">
                    <p class="sub-heading">On Board the tanker</p>
                    <p class="sub-heading">##OnBoardTanker##</p>
                </div>
                <div class="col-4" style="margin-left: 50px;">
                    <p class="sub-heading">Flag</p>
                    <p class="sub-heading">##Flag##</p>
                </div>
                <div class="col-4" style="margin-left: 50px;">
                    <p class="sub-heading">Master</p>
                    <p class="sub-heading">##Master##</p>
                </div>
            </div>
            <div class="col-12">
                <hr style="background: blue;">
            </div>
            <div class="row">
                <div class="col-4">
                    <p class="sub-heading">Loaded at the port of</p>
                    <p class="sub-heading">##LoadedAtPort##</p>
                </div>
                <div class="col-4" style="margin-left: 50px;">
                    <p class="sub-heading">To be delivered to the port of</p>
                    <p class="sub-heading">##DeliveredPort##</p>
                </div>
                <div class="col-4" style="margin-left: 50px;">
                    <p class="sub-heading">Voyage Number</p>
                    <p class="sub-heading">##VoyageNumber##</p>
                </div>
            </div>
            <div class="col-12">
                <hr style="background: blue;">
                <p class="sub-heading" style="margin-bottom: 10px;">A Quantity in bulk said by the Shipper to be:</p>
            </div>
            <div class="row">
                <div class="col-6">
                    <p class="sub-heading">COMMODITY (Name of product)</p>
                    <p class="sub-heading">##Commodity##</p>
                </div>
                <div class="col-6">
                    <p class="sub-heading" style="margin-left: 50px;">QUANTITY (lbs, tonnes, barrels, gallons</p>
                    <p class="sub-heading" style="margin-left: 50px;">##Quantity##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <p class="sub-heading">OCEAN CARRIAGE STOWAGE: ##OceanCarriageStowage##</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <p class="sub-heading">This shipment of <span> ##Quantity## </span> Metrie tons was loaded on board
                        the Vessel as part of one original lot of <span> ##Quantity## </span> Metrie tons stowed in
                        <span> ##SLOPS## </span> with no segregation as to parcels. For the whole shipment <span>
                            ##TotalBlNumbers## </span> set Of Bill of Lading have been issued for which the Vessel is
                        relieved from all responsibilities to the extent it would be if one sel only would have been
                        issued. The Vessel undertakes to deliver only that portion of the cargo actually loaded which is
                        represented by the percentage that the total amount specifed in the Bill(s) of Lading bears to
                        the foal of the commingling shipment delivered at destination. Neither the Vessel nor the overs
                        assume any responsibility for the consequences of such commingling nor for the separation
                        thereof at the time of delivery.
                    </p>
                    <p class="sub-heading" style="margin-top: 10px;">The quantity, measurement, weight, gauge, quality,
                        nature and value and actual condilion of the cargo unknorm to the Vessel and the Maser, lo be
                        delivered to the port of discharge or so near there to as the Vessel can safely get, always a
                        float upon prior payment of freight as agreed. Cargo is warranted free of danger to Vessel
                        except for the usual risks inherent in the carriage of the commodity as described.</p>
                    <p class="sub-heading" style="margin-top: 10px;">This shipment is carried under and pursuant to the
                        forms of the Charter daled <span> ##CharteredDate## </span> Between <span> AS PER CHARTER
                            PARTY </span> As Owners and <span> AS PER CHARTER PARTY </span> As Charterers, and all
                        conditions. Liberties And exception whatsoever of the said Charier apply to and govern the
                        rights of the parties concerned in this shipment. The Clause Paramount, New Jason Clause and
                        Both to Blame Collision Clause as set out on the reverse of this Bill of Lading are hereby
                        incorpornled herein and shall remain in effect even if unenforceable in the United States of
                        America, General Average payment according to the York-Antwerp Rules 1974, as amended 1994.</p>
                    <p class="sub-heading">The Master is authorized to act for all interests in arranging for salvage
                        assistance on lerms of Lloyds Open Form. The freight is payable discountless and is earned
                        concurrent with loading, ship and/or cargo lost or not lost or abandoned. </p>
                    <p class="sub-heading">The Overs shall have an absolute lien on he cargo for all freight.
                        Deadfreight, demurrage, damages for detention and all other monies due under the above mentioned
                        Charter or under this Bill of Lading, logether with the costs and expenses, including attorneys
                        fees, of recovering same, and shall be antitled to sell or otherwise dispose of the property
                        lined and apply the proceeds towards satisfaction of such liability.</p>
                    <p class="sub-heading" style="margin-top: 10px;">The contract of carriage evidenced by this Bill of
                        Lading is between the shipper, consignee and/or over of the cargo and the owner or demise
                        charterers of the Vessel named herein to carry the cargo described above,</p>
                    <p class="sub-heading">carrior or baile of said shipment or under any responsibility with respect
                        thereto, all limitations af or exonerations from liability and all defences provided by law or
                        by the terms of the contract of carriage shall be available to such other</p>
                    <p class="sub-heading" style="margin-top: 10px;">All of he provisions written, printed or stamped on
                        either side hereof are part of this Bill of Lading Contract. In Witness Whereof, the master has
                        signed <span> #3 (THREE) ORIGINALS# </span> Bills of Lading of this tenor and date, one of which
                        being accomplished, the others will be void.</p>
                    <p class="sub-heading">Dated at <span> ##IssuedPlace## </span> this <span> ##SignedDay## </span> day
                        of
                        <span> ##SignedMonth## </span> <span> ##SignedYear## </span>
                    </p>
                </div>
            </div>
            <div class="row">
                <div class="col-6" style="margin-top: 50px;"></div>
                <div class="col-6" style="margin-top: 50px;">
                    <hr style="background: #000;">
                    <p class="sub-heading" style="text-align: center;">As Agents for and on behalf the master</p>
                    <p class="sub-heading" style="text-align: center;">CAPT. SEO PAN GI</p>
                </div>
            </div>
            <div class="row terms-page-break">
                <div class="col-12" style="margin-top: 20px;">
                    <p class="sub-heading" style="font-weight: bolder;">BILL OF LANDING</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 5px;">
                    <p class="sub-heading">TO BE USED WITH CHARTER-PARTIES</p>
                </div>
            </div>
            <div class="row">
                <div style="width:38%"></div>
                <div class="col-6">
                    <p class="sub-heading">Conditions of Carriage</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(1) Ceneral Paramount Clause</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(a) The Hague Rules contained
                        in the International Convention for the Unification of certain rules relating to Bills of
                        Landing, dated Brussels the 25% August 1924 as enncted in the country of shipment, shall apply
                        to this Bill of Landing When no such enactment is in force the country of shipment. the
                        corresponding legislation of the country of destination shall apply, but in respect of shipments
                        to which no such enactments are compulsorily applicable, the terms of the said Convention shall
                        apply.</p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(b) Trades where Hauge-Visby
                        Rules apply. In trades where the International Brussels Convention 1924 as amended by the
                        Protocol signed at Brussels on February 23 196&- the Hague-Visby Rules-apply compulsorily, the
                        provisions of the respective legislation shall apply to this Bill of Landing</p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(c) The Carrier shall in no
                        case be responsible for the loss of or damage to the cargo, howsoever arising prior to loading
                        into and affer discharge from the Vessel or while the cargo is in the charge of another Carrier,
                        nor in respect of deck cargo or live animals.</p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(d) If the carriage covered
                        by this Bill of Landing includes Carriage to or from a port or place in the United States of
                        America, this Bill of Landing shall be subject to the United States Carriage of Goods by Sea Act
                        1939 (US COGS A), the terms of which are incorporated herein and shall govern throughout the
                        entire Carriage set forth in this Bill of Landing Neither the Hague or Hague-Visby Rules shall
                        apply to the Carriage to or from the United States. The Carrier shall be entitled to the
                        benefits of the defenses and limitations in US COGSA. whether the loss or damage to the Goods
                        occurs at sea or not.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(2) General Average</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">General Average shall be
                        adjusted, stated and settled according to York-Antwerp Rules 1994, or any subsequent
                        modification thereof, in London unless another place is agreed in the Charter Party. Cargos
                        contribution to General Avcrage shall be paid to the Carrier even when such average is the
                        result of a fault, neglect or error of the Master, Pilot or Crew. The Charterers, Shippers,
                        Consignees and the Holder of this Bill of Landing expressly renounce the Belgian Commercial
                        Code, Part II. Art. 148,</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(3) New Jason Clause</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">In the event of accident,
                        danger, or disaster before or after the commencement of the voyage, resulting from any cause
                        whatsoever, whether due to negligence or not, for which or for the consequence of which, the
                        Carrier is not responsible, by statute, contract or otherwise, the cargo, Shippers, Cosignees,
                        the Owners of the cargo or the Holder of this Bill of Landing shall contribute with the Carrier
                        in General Average to the payment of any sacrifices, losses or expenses of a General Average
                        nature that may be made or incurred and shall pay salvage and special charges incurred in
                        respect of the cargo. If a salving vessel, is owned or operated by the Carrier, salvage shall be
                        paid for as fully as if the said salving vessel or vessels belonged to strangers. Such deposit
                        as the Carrier, or his agents, may deem suflicient to cover the estimated contribution of the
                        goods and any salvage and special charges thereon shall, if required, be made by the cargo,
                        Shippers, Consignces or Owners of the goods or Holder of this Bill of Landing to the Carrier
                        before delivery.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(4) Both-to-Blame Collision Clause</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">If the Vessel comes into
                        collision with another vessel as a result of the negligence of the other vessel and any act,
                        neglect or default of the Master, Mariner. Pilot or the servants of the Carrier in the
                        navigation or in the management of the Vessel, the owners of the cargo carried hereunder and the
                        Holder of this Bill of Landing will indemnify the Carrier against all loss of liability to the
                        other or non-carrying vessel or her owners in so far as such loss or liability represents loss
                        of, or damage to, or any claim whatsoever of the owners of said cargo, paid or payable by the
                        vessel or her owners as part of their claim against the carrying Vessel or the Carrier. The
                        foregoing provisions shall also apply where the owners, operators or those in charge of any
                        vessel or vessels or objects other than, or in addition to, the colliding vessels or objects are
                        at fault in respect of a collision or contact.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(5) Notice of Loss or Damage to the Goods</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">Unless Notice of Loss or
                        Damage to the Goods and the general nature of such loss or damage be given in writing to the
                        Carrier or his agent at the port of discharge before or at the time of the removal of the goods
                        into the custody of the person entitled to delivery thereof under the contract of carriage, or,
                        if the loss or damage be not apparent within 3 (three) days, such removal shall be prima facie
                        evidence of the delivary by the carrier of the goods as described in the bill or landing
                        (Hague-Visby Rules Article Ill Rule 6)</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(6) Time Bar</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">All liability whatsoever of
                        the Carrier shall cease unless suit is brought within 1 (one) year after delivery of the goods
                        or the date when the goods should have been delivered,</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(7) Cargo loss</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">The Carrier shall not be
                        liabla for any short outturn cargo quantity below 0.5% as determined by the discrepancy between
                        the quantity of cargo received onboard the vessel in Port of Loading and the ships ligure in
                        Port of Discharge</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(8) Limitation of Liability</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">The Carrier shall have the
                        benefit of all applicable imitations of an exemptions from liability accorded to the Carrier by
                        any laws, statues, or regulations of any country for the time being in force notwithstanding any
                        provision of the charterparty</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">
                    <h5>(9) Himalaya Cargo Clause</h5>
                    </p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">It is hereby expressly agreed
                        that no servant or agent of the Carrier (including every independent contractor from time to
                        time employed by the Carrier) shall in any circumstances whatsoever be under any liability to
                        the shipper. Consignce or owner of the cargo or to any Holder of this Bill of Landing for any
                        loss, damage or delay of whatsoever kind arising or resulting directly or indirectly from any
                        act, neglect or default on his part while acting in the course of or in connection with his
                        employment and, but without prejudice to generality of the foregoing provisions in this Clause,
                        every exemption, limitation, condition and liberty herein contained and every right, exemption
                        from liability, defense and immunity of whatsoever nature applicable to the Carrier or to which
                        the Carrier is entitled hereunder shall also be available and shall extend to protect every such
                        servant pr agent of the Carrior acting as aforesaid and for the purpose of all the foregoing
                        provisions of the Clause the Carrier is or shall be deemed to be acting as agent or trustee on
                        behalf of and for the benefit of all persons who are or might be his servants or agent from time
                        to time (including independent contractions as aforesaid) and all such-persons shall to this
                        extent be or be deemed to be parties to the contract in or evidenced by this Bill of Landing The
                        Carrier shall be entitled to be paid by the Shipper. Consignee, owner of the cargo and or Holder
                        of the Bill of Landing (who shall be jointly and severally liable to the carrier therefore) on
                        demand any sum recovered or recoverable by either such Shipper, Consignes, owner of the cargo
                        and or Holder of the Bill of Landing or any other from such servant or agent of the Carrier for
                        any such loss, damage, delay or otherwise.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 10px;">
                    <p class="sub-heading">All terms and conditions, liberties and exceptions of the BIMCO War Risk
                        Clause for Time Charters,</p>
                    <p class="sub-heading">2004 (Codename: Conwartime 2004) and amendments thereto are herewith
                        incorporated.</p>
                </div>
            </div>
        </div>
    </div>
</body>

</html>
' where EmailTemplateName='switchblpdfgenerationtemplate' AND CompanyId =  @CompanyId


update emailtemplates set EmailTemplate = '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vessel Contract</title>
    <style>
        body{
            background-color: #F6F6F6; 
            margin: 0;
            padding: 0;
        }
        
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
        h1,h2,h3,h4,h5,h6{
            margin: 0;
            padding: 0;
        }
        p{
            margin: 0;
            padding: 0;
        }
        .container{
            width: 95%;
			/* width: 100%; */
            margin-right: auto;
            margin-left: auto;
			margin-top: 35px;
    		margin-bottom: 35px;
        }
        .brand-section{
           background-color: #0d1033;
           padding: 10px 40px;
        }
        .row{
            display: flex;
            flex-wrap: wrap;
        }

		.mt-15 {
			margin-top: 15px;
		}

		.col-4{
            width: 33%;
            flex: 0 0 auto;
        }

        .col-6{
            width: 50%;
            flex: 0 0 auto;
        }
		.col-12{
            width: 100%;
            flex: 0 0 auto;
        }
		.col-part-1{
            width: 50%;
            flex: 0 0 auto;
        }
		.col-part-12{
            width: 100%;
            flex: 0 0 auto;
        }
        .text-white{
            color: #fff;
        }
        .company-details{
            float: right;
            text-align: right;
        }
        .heading{
            font-size: 20px;
            margin-bottom: 08px;
        }
        .sub-heading{
            color: #262626;
            margin-bottom: 05px;
        }
        .w-20{
            width: 20%;
        }
        .float-right{
            float: right;
        }
		.text-center{
			text-align: center;
		}
        span {
            text-decoration: underline;
            color: blue;
        }
		ol {
			margin-block-start: 1em;
			margin-block-end: 1em;
			margin-inline-start: 0px;
			margin-inline-end: 0px;
			padding-inline-start: 21px;
		}
		li {
			padding-left: 15px;
			padding-bottom: 15px;
		}

		.red-text-back-yellow {
			background-color: yellow;
			color: red;
			text-decoration: none;
		}

		.red-text {
			color: red;
			text-decoration: none;
		}

    </style>
</head>
<body>
    <div class="container">
    <div id="pageborder">
        </div>
        <div class="body-section">
            <div class="float-right row">
                <div class="col-12">
                    <p class="sub-heading">VEGOILVOY 1/27/50</p>
                </div>
            </div>
			<br>
			<br>
			<div class="row text-center">
                <div class="col-12">
					<p class="sub-heading" style="margin-left: 50px; font-size: 26px; font-weight: bolder;">TANKER VOYAGE CHARTER PARTY</p>
                    <p class="sub-heading" style="margin-left: 50px; font-weight: bolder;">PREAMBLE</p>
                </div>
            </div>
			<div class="row">
                <div class="col-12">
                    <p class="sub-heading">CHARTER PARTY made as of ##ContractDate## at ##ContractPlace##</p>
                    <p class="sub-heading">by and between ##ByAndBetween##
					    (herein after called the “owner”)##Owner## of the good  MS/SS</p>
                    <p class="sub-heading">(hereinafter called the “Vessel”)##Vessel## and </p>
					<p class="sub-heading">Charterer (hereinafter called the “Charterer”)##Charterer##.</p>
                </div>
            </div>			
			<br>
            <div class="row">
                <div class="col-12">
					<p class="sub-heading">The Vessel shall receive from the Charterer or supplier at the port or ports of loading, or so near thereto as she may safely get, always aftoat, the cargo described in Part I, for delivery as ordered on signing bills 
						of lading to the port or ports of discharge, or so near thereto as she may safely get always aftoat, and there discharge the cargo, all subject  to the terms, provisions, exceptions and limitations contained or incorporated in this 
						Charter Party, which shall include the foregoing preamble and Parts I and II. In the event of a conflict, the provisions of Part I shall prevail over those contained in Part II to the extent of such conflict.</p>
					<br>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Each of the provisions of this Charter Party shall be and be deemed severable, and if any provision or part of any provision should be held invalid, illegal or unenforceable, the 
						remaining provisions or part or parts of any provisions shall continue in full force and effect.</p>
                </div>
            </div>
			<br>
			<div class="row text-center">
                <div class="col-12">
                    <p class="sub-heading" style="margin-left: 50px; font-weight: bolder;">PART I</p>
                </div>
            </div>
			<div class="row">
				<div class="col-12">
                    <ol type="A">
					  <li>
						<p class="sub-heading">Description and Position of Vessel: ##descriptionAndPositionOfVessel##</p>
						<p class="sub-heading">Net Registered Tonnage: ##Tonnage##</p>
						<p class="sub-heading">Total Deadweight: ##Deadweight## 
						<!--tons of 2,240 lbs. each on ##draftinsaltwater## draft in salt water on assigned summer freeboard.-->
						</p>
						<!--<p class="sub-heading">Capacity for cargo: ##Capacity## bbls. of 42 American gallons each at 60deg F. or ##tons## tons of 2,240 lbs. each(10% more ore less, Vessel''s option.) </p>-->
						<!-- <div class="row">
							<div class="col-6">
								<p class="sub-heading">Classed: ##Classed##</p>
							</div>
							<div class="col-6">
								<p class="sub-heading">Now: ##Now##.</p>
							</div>
						</div> -->
					  </li>
					  <li>
						<p class="sub-heading">Part-Full Cargo.</p>
						<p class="sub-heading">##PartFullCargo##</p>
						<p class="sub-heading">In this Charter Party is for a full cargo, then it shall be the quanity the Vessel can carry if loaded to her minimum permissible freeboard for the voyage, 
							but not exceeding what the Vessel can, in the Master''s judgment, reasonably stow and carry over and above her tackle, apparel, stores, and furniture, sufficient space to be left 
							in the expansion tanks to provide for the expansion of the cargo. In no event shall Charterer be required to furnish cargo in excess of the quantity stated as the Vessel''s 
							capacity for cargo plus 10% of that quanity. If less than a full cargo is to be carried, the quantity stated shall be the minimum quantity which the Charterer is required to supply.</p>
					  </li>
					  <li>
						<p class="sub-heading">Loading Port. ##LoadingPort##</p>
						<br>
						<div class="row">
							<div class="col-6">
								<p class="sub-heading">Readiness Date: ##ReadinessDate##</p>
							</div>
							<div class="col-6">
								<p class="sub-heading">Cancelling Date: ##CancellingDate##</p>
							</div>
						</div>
					  </li>
					  <li>
						<p class="sub-heading">Discharge Port. ##DischargePort##</p>
					  </li>
					  <li>
						<p class="sub-heading">Total Laytime</p>
						<div class="row">
							<div class="col-6">
							</div>
							<div class="col-6">
								<p class="sub-heading">for loading: ##forloading##</p>
							</div>
						</div>
						<div class="row">
							<div class="col-6">
								##TotalLaytime##
							</div>
							<div class="col-6">
								<p class="sub-heading">for discharging ##fordischarging##</p>
							</div>
						</div>
						<p class="sub-heading">(Running Hours.)</p>
					  </li>
					  <li>
						<p class="sub-heading">Freight Rate. ##FreightRate##</p>
						<br>
						<br>
						<p class="sub-heading">Freight Payable at: ##FreightPayableAt##</p>
					  </li>
					  <li>
						<p class="sub-heading">Demurrage per Hour. ##DemurragePerHour##</p>
					  </li>
					  <li>
						<p class="sub-heading">Sepcial provisions. ##SepcialProvisions##</p>
					  </li>
					</ol>
                </div>
				<div class="col-12">
					<p class="sub-heading">IN WITNESS WHEREOF the parties hereto have executed this agreement, in duplicate, as of the day and year first above written.</p>
				</div>
				<div class="row col-12">
					<div class="col-12">
						<p class="sub-heading">Witness to signature of: ##WitnessToSignatureOf1##</p>
					</div>
				
					<div class="col-6">
					</div>
					<div class="col-6">
						<p class="sub-heading">By: ##By1##</p>
					</div>
				
					<div class="col-12">
						<p class="sub-heading">Witness to signature of: ##WitnessToSignatureOf2##</p>
					</div>
				
					<div class="col-6">
					</div>
					<div class="col-6">
						<p class="sub-heading">By: ##By2##</p>
					</div>
				</div>
            </div>
			<br><br>
			<div class="row">
                <div class="col-12">
					##ShipBrokerDetails##
				</div>
			</div>
			<br><br><br>
			<div class="row text-center">
                <div class="col-12">
                    <p class="sub-heading" style="margin-left: 50px; font-weight: bolder;">PART II</p>
                </div>
            </div>
			<div class="row">
                <div class="col-12">
                    <p class="sub-heading" style="font-weight: bolder;">Rider Clauses 1 to 34 To be used in conjunction with STD VEGOILVOY Charter Party.</p>
                </div>
            </div>
			<div class="row">
                <div class="col-12">
					<br>
					<p class="sub-heading" style="font-weight: bolder;">1. NOTICE OF READINESS</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NOR to be tendered within laydays at the official designated pilot station.</p>
					<br>
					<p class="sub-heading" style="font-weight: bolder;">2. LAYDAYS</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; If vessel is able to and Charterer so instruct, the vessel shall load prior commencement of first layday.</p>
					<br>
					<p class="sub-heading">Charterers shall have the benefit 50% of such time saved when calculating laytime and/or demurrage at subsequent ports of call. Such benefit 
						shall be the total time between commencement of loading and the commencement of the first layday </p>
					<br>
					<p class="sub-heading" style="font-weight: bolder;">3.	BILL OF LADING AND CARGO RELEASE</p>
					<br>
					<p class="sub-heading">Immediately upon completion of loading, owner / agent to release bills of lading marked “clean on board” or "clean shipped on board" and 
						“freight as per Charter Party” or “freight collect” to shippers. Upon confirmation of freight receipt by owner or proof of payment by bank telex or remittance slip, 
						owner / agents to endorse bills of lading to “freight pre-paid” if required.</p>
					<br>
					<p class="sub-heading">For such “clean on board” bills of lading, it is always understood that such Notation (including cargo specifications and / or letter of credit markings) 
						are Strictly for bank’s letter(s) of credit purposes which does not refer to quality / Quantity, and would not alter the terms and conditions of this Charter party. Charterer to 
						have option to switch B/L or to exchange local for global bills of lading basis one-to-One exchange basis <span class="red-text-back-yellow">before/after (optional)</span>
						discharging full cargo, at load port or Singapore at no any costs <span class="red-text">and/or time</span> <s>to</s> <span class="red-text">is for</span>  charterer’s
						<span class="red-text">account and</span> <s>but</s> charterer to Provide a letter of indemnity (hereinafter referred to as “LOI”) (as per Owner’s P&I Club format) to legally 
						effect the change of cargo ownership until such time the Local bills of lading are surrendered for switching. Strictly no double issuance of Bills of lading.
					</p>
					<br>
					<p class="sub-heading">
						Owners shall prepare, issue and release Bills of Lading as per charterer''s instructions. Charterer shall have the option for all or part of the Bills of Lading to be released 
						either at load ports or at Singapore. If there is any issuance/switching of Bills of Lading in Singapore or loadport, owner agrees to nominate and appoint agent for this purpose as 
						per charterer''s instructions, <span class="red-text">any cost and/or time for such operation is for charterer’s account</span>. Owner to issue 2nd set bills of lading at loadport or in 
						Singapore but such bills of lading will remain in owners/agents office until the 1st set of local bills of lading are surrendered to owners/agents'' office. Once the 1st set or local 
						bills of lading are surrendered, owners are to release the 2nd set bills of lading within 24 hours to charterer <s>without additional cost to Charterer</s>. Owners must release 
						a signed copy of 2nd set bills of lading (non-negotiable copy) to charterer for customs clearance purposes only. For B/L switching to be carried out at Singapore only.
					</p>
					<br>
					<p class="sub-heading">
						It is understood that as long as any original set of bills of ladings are returned to owner of their agents, the rest of the bills of lading are considered null and void, and thus 
						charterer’s letter of indemnity is also null and void. As per LOI terms.
					</p>
					<br>
					<p class="sub-heading">
						Charterers shall have the option to continue switching of BL even after discharge of cargo. Charterer shall always complete B/L switching within 10 working days after discharge. 
						Any switching will always be against Charterers LOI 
					</p>
					<br>
					<p class="sub-heading">
						Charterers to provide a letter of indemnity (herein after referred to as ‘LOI’) to legally effect the change of cargo ownership until such time the local bills of lading are surrendered 
						for switching. There shall be strictly no double issuance of bills of lading.
					</p>
					<br>
					<p class="sub-heading" style="font-weight: bolder;">4.	SHIFTING</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Shifting one time from anchorage anchor aweigh to berth shall not count as used laytime.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Charterer to have the option to shift the vessel to additional berth (s) at Charterers expenses, Charterers shall pay all expenses incurred 
						and settle them directly (owner to assist to highlight to agent about the shifting charges), additional bunkers consumed shall be paid by charterers, time used to count as laytime or 
						demurrage time, if vessel is on demurrage.</p>
					<br>
					<p class="sub-heading" style="font-weight: bolder;">5.	DEMURRAGE</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Demurrage, if any, payable within 60 days after presentation & acceptance of owners documented invoice together with available 
						supporting documents.Owner to present to charterer any demurrage/ any claims within 30 days after completion of discharge.
					</p>
					<br>
					<p class="sub-heading" style="font-weight: bolder;">6.	VESSEL SUBSTITUTION</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Substituting of vessel is subjected to Charterer approval but not unreasonably withheld basis description and characteristics of the 
						substitute vessel, being at least the standard and suitability and no extra cost being incurred by the Charterer, compared to the vessel initially named.
					</p>
					<br>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Any substitution request from the owners must be notified to charterer latest by 7 days before commencement of laycan. In the event 
						of any substitution, the laycan has to remain unchanged unless otherwise agreed.
					</p>
					<br>
					<p class="sub-heading" style="font-weight: bolder;">7.	HEATING OF CARGO: N/A FOR THIS VOY, SHIP IS NO HEATING ONE</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Vessel to heat cargo according to charterer''s or shipper''s instructions received but such instruction must always be in line with 
						FOSFA heating instruction in respect of bulk shipment of oils and fats. In the absence of such instructions, owner/master to follow FOSFA heating instructions for the grade (s) of cargo 
						carried. Vessel''s heating system/coils to be steam driven and strictly no thermal heating system/coils to be used.
					</p>
					<br>
					<p class="sub-heading" style="font-weight: bolder;">8.	CLEANLINESS OF TANKS</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Vessel to clean tanks, lines and pumps to charterer’s inspector''s satisfaction, which shall not be unreasonably withheld</p>
					<br>
					<p class="sub-heading" style="font-weight: bolder;">9.	SUITABILITY</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; A)	Last 3 cargoes clean and unleaded and suitable for carriage of vegetable oil.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; B)	Last 3 cargoes not to be tallow, lard, animal fats and edible alcohol.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C)	Immediate last cargo of tank(s) used to load subject cargoes to conform with FOSFA International list of banned immediate 
						previous cargoes dated 1st JAN 2008 requirement.</p>
					<br>
					<br>
					<p class="sub-heading" style="font-weight: bolder;">10.	LAYTIME</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; If part cargo, vessel loads/discharge cargo for other charterers at same berth(s) all time including waiting at berth(s) or at 
						anchorage for berth, time used and /or waiting time of demurrage if any, is to be prorated in accordance with respective cargo quantities of each charterer, where waiting time, time used 
						and or time of demurrage results from the act of any specific charterer such time will attributed to such Charterer.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Charterers shall be allowed three (3) hours for documentation at all load and discharge ports after completion loading or 
						discharging</p>
					<br>
					<p class="sub-heading" style="font-weight: bolder;">11.	FOSFA INTERNATIONAL REGULATIONS</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Owner/master to comply with the following FOSFA International regulations:</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Charterers shall be allowed three (3) hours for documentation at all load and discharge ports after completion loading or 
						discharging</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (i)	Operational procedures for ocean carriers in force at the date of loading. Qualification for all ships engaged in the 
						ocean carriage and transshipment of oils and fats for edible and oleo - chemicals use in force at the date of loading.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (ii) In case fixture referring to transshipment procedure, owners also to comply with FOSFA operational regulation 
						for transshipment vessels in force at the date of loading.</p>

					<br>
					<p class="sub-heading" style="font-weight: bolder;">12.	IACS/IRS CLAUSE</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; To the best of Owner’s knowledge, Vessel shall satisfy the requirements and guidelines of the Directorate General of Shipping of the Ministry 
						of Shipping of India. In particular, Owner must ensure that the following conditions are complied with: </p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (i)	Vessel has to be below 25 years of age.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (ii) Owner to ensure that if Vessel is above 20 years of age, she must have at least CAP 2 rating (for hull, machinery 
						and cargo equipment) either with a full member of the International Association of Classification Society (IACS) or India Register of Shipping (IRS).</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (iii)	Owner to ensure that the Vessel is classed either with a full member of the International Association of 
						Classification Society (IACS) of India Registry of Shipping (IRS).</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; In the event the above is not complied with, the owner shall indemnify charterer and shall be responsible for all costs and 
						expenses, losses, damages, liabilities as a result of non/compliance including but not limited to Vessel not being permitted to enter Indian ports of off-shore installations, or 
						anchor in areas under the jurisdiction of the India Port.</p>

					<br>
					<p class="sub-heading" style="font-weight: bolder;">13.	ELIGIBILITY AND COMPLIANCE</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Owner to warrant that the classification of the vessel is equivalent to Lloyds 100A1 and vessel has all relevant trading certificates 
						throughout the period of this charter.</p>
					
					<br>
					<p class="sub-heading" style="font-weight: bolder;">14.	IN TRANSIT CARGO ONBOARD</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Strictly no low flash cargoes are allowed in transit onboard vessel at both load and discharge ports.</p>

					<br>
					<p class="sub-heading" style="font-weight: bolder;">15.	FOR CHINA DISCHARGE - N/A</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Last three cargoes to be edible products i.e. vegetable oil, tallow molasses etc or its equivalent.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Discharging at Nanjing, China NOR to be tendered upon vessel''s arrival at the official customary anchorage 
						designated by the port authority, i.e. Yizheng anchorage. </p>

					<br>
					
                </div>
            </div>
			<div class="row">
                <div class="col-12">
					<p class="sub-heading" style="font-weight: bolder;">16.	FOR INDIA DISCHARGE</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; A) Owner to ensure that gas free certificate and all trading certificates required by the Indian port 
						authorities (including free pratique) are obtained before tendering of notice of readiness for discharging port.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; B)	In the absence of original bills of lading, owner to release the entire cargoes to receivers against 
						charterers’ letter of indemnity (wording as per owner’s P and I Club format. </p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C)	For Pakistan discharge, in the absence of original bills of lading, owner to release the entire Cargo 
						to receivers against charterer’s letter of indemnity (wordings as per owner’s PNI club format with charterer slight amendment which refers to replacing the word 
						“person” with “company” without bank guarantee) 
					</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Alternatively, in charterer’s option, cargo to be discharged into bonded shore tanks and to be released 
						only against presentation of original bills of ladings. Charterer to provide with letter of indemnity (wording as per owner PNI club format for discharge of 
						cargoes into bonded shore tanks.
					</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D)	For Chittagong discharge </p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; At Chittagong, owner/Master to discharge the entire cargo into bonded shore tanks against charterer’s letter 
						of indemnity (wording as per owner’s P and I Club format without bank guarantee and cargo to be released only against presentation of original bills of lading at 
						discharge port, or, in charterer’s option against charterer’s letter of indemnity wording as per owner’s P and I Club format. – Not Applicable </p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; E)	For discharge at Calcutta, Sandheads clause shall apply which reads as under :</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; “If order to Calcutta and vessel waits at Sandheads due to congestion at Calcutta port or there is insufficient 
						water for vessel to proceed or there is bore -tide at time of arrival at Sandheads, laytime shall commence to count as at 06.00 8.00 a.m. on the next working day 
						(<span class="red-text">(Saturday, Sunday and/or holiday are counted as working days)</span> after notice of vessel’s arrival has been given by radio 
						<span class="red-text">and/or email</span> to receivers or their agents and received 
						during ordinary office hours. Whilst waiting of Sandheads, Sundays, holidays and Saturdays after 12.00 noon until 8.00 a.m. on Monday <s>not</s> <span class="red-text">
						to count as laytime or demurrage if vessel is on demurrage</span> <s>(unless vessel is on demurrage.) </s>time from declaration by the port authorities that sufficient water 
						is available for vessel to proceed from Sandheads to Calcutta including transit time shall not count which is <span class="red-text">To apply on for the period where there 
						is bore tide</span>. Waiting time as above shall be divided on pro-rata basis among the cargoes 
						destined for loading / discharging in Calcutta <span class="red-text">(budge budge)</span>.</p>
					<br>
				</div>
			</div>
			<div class="row">
                <div class="col-12">
					<p class="sub-heading" style="font-weight: bolder;">17.	CONOCO WEATHER CLAUSE</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Delays in berthing for loading or discharging and any delay after berthing which are due to weather conditions 
						shall count as one half laytime, if on demurrage, at one-half demurrage rate. </p>
					
					<br>
					<p class="sub-heading" style="font-weight: bolder;">18.	CARGO HANDLING</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Owner not to use fittings/lines/pumps/tanks or any other materials containing or made of copper and/or copper 
						alloys when handling this cargo. </p>
					
					<br>
					<p class="sub-heading" style="font-weight: bolder;">19.	CARGO SHORTAGES </p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Owner not to be responsible for any loss and/or shortage of cargoes incurred outside of ship''s manifold including 
						the 0.5% tolerance loss allowable in the vegetable oil trade. <span class="red-text">Owners are only responsible for any loss exceed 0.5% in-transit loss of entire quantity 
						loaded only. Ship Figs at loadport  after loaing Vs Ship Figs at disport before unloading. </span></p>
					
					<br>
					<p class="sub-heading" style="font-weight: bolder;">20.	WHARFAGE/DOCKAGE</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Wharfage / dockage / taxes/dues on cargo <span class="red-text">and/or freight</span> , if any, to be for Charterer’s account.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Wharfage/dockage/taxes/dues on vessel if any, to be for Owner’s account.</p>

					<br>
					<p class="sub-heading" style="font-weight: bolder;">21.	ETA NOTICES</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Owner/master/agents to give 7/5/3/2/1 days and 12 hours ETA notice where applicable at load/discharge port(s) to 
						charterer via broker and to the agents.</p>

					<br>
					<p class="sub-heading" style="font-weight: bolder;">22.	MASTER’S WRITTEN AUTHORIZATION CLAUSE</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Owner will procure master to provide written authorization to agents at load port and also Singapore (if requested by 
						the charterers) to enter into and do all thing necessary for the proper execution and signing on behalf and in the name of the master of bills of lading and other documents 
						in relation to the carriage of goods shipped onboard the vessel. One original of such authorization shall be handed to the charterer''s representative at load port before 
						completion of loading. </p>

					<br>
					<p class="sub-heading" style="font-weight: bolder;">23.	AGENTS</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1)	Charterer shall recommend nominate the vessel’s agents at load and discharge port(s) but such agent shall be 
						employed, instructed and paid by Owners provided competitive. Port disbursement is always subject competitive.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Appointing charterers agents both end but always provided competitive, instructed and paid by Owners</p>

					<br>
					<p class="sub-heading" style="font-weight: bolder;">24.	WAR RISK PREMIUM - N/A</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Additional war risk premium if any, to be for Owners account.</p>

					<br>
					<p class="sub-heading" style="font-weight: bolder;">25.	LIGHTERING BY BARGE/SHIP TO SHIP/TRANSFER/DOUBLE BANKING CLAUSE</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Charterer has the option to carry out loading, discharging or lightening operation by barges or ship to ship transfer. 
						Charterer shall provide adequate fenders and flexible hoses <span class="red-text">and/or any other necessary equipment</span>  for such an operation and always to master sole 
						discretion which are not unreasonably withheld. <span class="red-text">Any costs which may arise from</span> such operation is for charterer’s account <s>at Charterer</s> and time 
						<span class="red-text">used</span> <s>and</s> to count as laytime <span class="red-text">or demurrage if vessel is already on demurrage.</span>
					</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; For safe load / discharging operation by ship-to-ship, Charterer shall arrange / provide all necessary vessel(s) and/or 
						barge(s) with safe and sufficient fender(s) / flexible hose(s) facilities including standby tugs and mooring master, if required. Permission of all concerned authorities and 
						officials with Charterer’s vessel(s) and/or barges shall be alongside safely to owner’s vessel in her safe afloat position. All above will be subjected to sea & weather condition 
						and master’s approval. All ship-to-ship cost as said shall be for Charterer’s account and be paid / settled by Charterer directly to the agent. Full laytime to be counted upon 
						NOR tendered regardless weather condition.</p>

				   	<br>
					<p class="sub-heading" style="font-weight: bolder;">26.	LETTER OF INDEMNITY</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; If original B/L is not available for discharging, the vessel is to discharge entire cargo(es) or proceed to the assigned 
						port against charterer’s LOI (wording as per Owner’s  P&I club format) Discharge of cargoes will be against OBL presented at disport.</p>

					<br>
					<p class="sub-heading" style="font-weight: bolder;">27.	GENERAL AVERAGE</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; General average, if any, in Singapore in accordance to York Antwerp Rules 1994.</p>

					<br>
					<p class="sub-heading" style="font-weight: bolder;">28.	ARBITRATION</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Arbitration, if any, in Singapore London under English Law.</p>

					<br>
					<p class="sub-heading" style="font-weight: bolder;">29.	BIMCO CLAUSE</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BIMCO Standard ISM clause for voyage and time charter parties to apply as follows:</p>
					<br>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; From the date of coming into force of the International Safety Management (ISM) code in relation to the vessel and thereafter 
						during the currency of this charter party, the owners shall procure that both the vessel and ''the company'' (as defined by the ISM code) shall comply with the requirements of the 
						ISM code. Upon request the owners shall provide a copy of the relevant Document of Compliance (DOC) and Safety Management Certificate (SMC) to the charterers.</p>
					<br>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Except as otherwise provided in this charter party, loss, damage, expense or delayed caused by the failure on the part of the 
						owners or ''the company'' to comply with the ism code shall be for owner’s account.</p>

					<br>
					<p class="sub-heading" style="font-weight: bolder;">30.	BIMCO ISPS CLAUSE</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BIMCO ISPS Clause for voyage charter parties to apply with the following amendments:</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (i)	From the date of coming into force of the International Code for the Security of Ships and of Port Facilities 
						and the relevant amendments to Chapter XI of SOLAS (ISPS Code) in relation to the Vessel, the Owners shall procure that both the Vessel and "the Company" (as defined by the ISPS Code) 
						shall comply with the requirements of the ISPS Code relating to the Vessel and “the Company”. Upon request the Owners shall provide a copy of the relevant International Ship Security 
						Certificate (or the Interim International Ship Security Certificate) to the Charterers. The Owners shall provide the Charterers with the full style contact details of the Company 
						Security Officer (CSO).</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (ii) Except as otherwise provided in this Charter Party, loss, damage, expense or delay, excluding consequential 
						loss, caused by failure on the part of the Owners or “the Company” to comply with the requirements of the ISPS Code or this Clause shall be for the Owners’ account.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (iii) The Charterers shall provide the CSO and the Ship Security Officer (SSO)/Master with their full style contact 
						details and any other information the Owners require to comply with the ISPS Code. </p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (iv) Except as otherwise provided in this Charter Party, loss, damage, expense, excluding consequential loss, 
						caused by failure on the part of the Charterers to comply with this Clause shall be for the Charterers’ account and any delay caused by such failure shall be compensated at the 
						demurrage rate.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Provided that the delay is not caused by the Owners’ failure to comply with their obligations under the ISPS Code, the following 
						shall apply:</p>
					<br>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Notwithstanding anything to the contrary provided in this Charter Party, the Vessel shall be entitled to tender Notice of Readiness 
						even if not cleared due to applicable security regulations or measures imposed by a port facility or any relevant authority under the ISPS Code.</p>
					<br>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Any delay resulting from measures imposed by a port facility or by any relevant authority under the ISPS Code shall be apportioned 
						equally between the Owners and the Charterers except that:</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; any such delay which is caused by the Owners'' fault or negligence shall be for the Owners'' account;</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; any such delay which is caused by the Charterers'' fault or negligence shall be for the Charterers'' account.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Any such delay which is apportioned to the Charterers or for the Charterers'' account shall count as laytime or time on demurrage 
						if the vessel is on laytime or demurrage; or if it occurs before laytime has started or after laytime or time on demurrage has ceased to count, it shall be compensated by the Charterers 
						at the demurrage rate.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; any such costs or expenses which are caused by the Owners'' fault or negligence shall be for the Owners'' account; any such costs 
						or expenses which are caused by the Charterers'' fault or negligence shall be for the Charterers'' account.</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; All measures required by the Owners to comply with the Ship Security Plan shall be for the Owners'' account."</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; If either party makes any payment which is for the other party’s account according to this Clause, the other party shall 
						indemnify the paying party.</p>

					
					<br>
					<p class="sub-heading" style="font-weight: bolder;">31.	FORCE MAJEURE CLAUSE</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; It is mutually agreed that neither parties shall be responsible or liable for any losses or damages (including demurrage and 
						other liquidated damages) or delays in discharging or failure to discharge or deliver the cargo arising or resulting from war, terrorist activities, acts of public enemies, strikes, 
						lockouts, rebellion,  civil commotion, act of god, government or port action or regulations, provided that any such event is supported by written, valid documented evidence and 
						publicly declared or any other hindrance or cause happening beyond the party''s control and not arising or resulting from the fault of the party. Neither the Charterers, nor 
						Shippers, nor Receivers, shall be liable for any such losses, damages, expenses or delays and all time lost by reasons thereof, shall not count as laytime or time on demurrage.</p>
					<br>
					<p class="sub-heading">- COMMINGLING CLAUSE :</p>
					<p class="sub-heading">a) Owner hereby agreed for comingling/blending onboard as per charterer''s instructions and they will cooperate with on board blending of cargoes. 
						Charterer to provide Owner with a letter of indemnity (wording as per Owner’s P&I Club format) without bank guarantee for the blending operation. All blending charges/costs/
						time/risk to be for Charterer’s responsibility.</p>
					<p class="sub-heading">b) For on board blending, two or more separate grades of cargo will be loaded into the same tank for comingling/blending. Owner to release local bills of lading 
						to shippers stating exact grade of cargo loaded. Upon surrendering of local bills of lading to Owner, Owner to issue global bills of lading to charterer stating grade of final 
						product provided by Charterer. Charterer to ensure that the bearer of local bills of lading will not negotiate with Owner/ agents/subject vessel for delivery of cargoes.</p>
					<br>
					<p class="sub-heading">If charterers require, blending may be carried out via shore tanks or via barge. The conditions stated in the above paragraph - a and b will apply.</p>
					<br>
					<p class="sub-heading">Charterers have the option of adding red dye to the cargo at the time of loading. This will always be supported by Charterers LOI.</p>

					<br>
					<br>
					<p class="sub-heading" style="font-weight: bolder;">32.	MARPOL ANNEX 2</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Owners warrant that vessel is in all respects eligible to carry vegetable oils fats as per the revised MARPOL Annex 2 
						regulations which will come in force effective January 1st, 2007.</p>

					<br>
					<p class="sub-heading" style="font-weight: bolder;">33.	VEGOIL VOY CHARTER PARTY AND UOPC</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Otherwise as per Vegoilvoy charter party with usual owners'' protective clauses:</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; A)	New Jason Clause</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; B)	U.S.A .Clause Paramount</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C)	Chamber of Shipping War 1/2/3 (Tankers) 1952</p>
					<p class="sub-heading">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D)	 Both to Blame Collision Clause</p>
				</div>
			</div>

			<br>
			<div class="row text-center">
                <div class="col-12">
                    <p class="sub-heading" style="font-weight: bolder;">~END~</p>
                </div>
            </div>


        </div>    
    </div>      
</body>
</html>' where EmailTemplateName='VesselContractFinalPdfTemplate' AND CompanyId =  @CompanyId


update emailtemplates set EmailTemplate = '<!DOCTYPE html>
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
                            <td style="padding-bottom: 15px;">Origin</td>
                            <td style="padding-bottom: 15px;">: ##Origin##
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

</html>' where EmailTemplateName= 'ContractFinalPdfTemplate' AND CompanyId =  @CompanyId
END
