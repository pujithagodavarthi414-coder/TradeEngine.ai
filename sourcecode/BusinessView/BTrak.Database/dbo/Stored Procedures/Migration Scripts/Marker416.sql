CREATE PROCEDURE [dbo].[Marker416]
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
    
    </html>' WHERE EmailTemplateName ='BLDraftPurchaseTemplate'
    UPDATE EmailTemplates SET EmailTemplate ='<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>INVOICE</title>
    <style>
        body{
            background-color: #F6F6F6; 
            margin: 0;
            padding: 0;
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
        .brand-section{
           background-color: #0d1033;
           padding: 10px 40px;
        }
        .row{
            display: flex;
            flex-wrap: wrap;
        }
        .col-6{
            width: 50%;
            flex: 0 0 auto;
        }
        .text-white{
            color: #fff;
        }
        .company-details{
            float: right;
            text-align: right;
        }
        .body-section{
            padding: 16px;
            border: 1px solid gray;
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
        span {
            text-decoration: underline;
            color: blue;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="body-section">
            <div class="row">
                <div class="col-6">
                    <p class="sub-heading">Shipped in apparent good order and condition by</p>
                    <hr style="background: blue;">
                    <p class="sub-heading">Shipper</p>
                </div>
                <div class="col-6">
                    <p class="sub-heading" style="margin-left: 50px; font-size: 26px; font-weight: bolder;">Tanker Bill of Landing</p>
                    <p class="sub-heading" style="margin-left: 50px; font-weight: bolder;">B/L NO. CY/DMI/HAL-02</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">#ShipperAddress#</p>
                    <hr style="background: blue;">
                    <p class="sub-heading">Consignee/Order of</p>
                </div>
            </div>
            <div class="row">
                <div class="col-6">
                    <p class="sub-heading">TO ORDER</p>
                    <br>
                    <hr style="background: blue;">
                    <p class="sub-heading">Notify Address</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading">#NotifyAddress#</p>
                </div>
            </div>
            <div class="col-12">
                <hr style="background: blue;">
            </div>
            <div class="row">
                <div class="col-4">
                    <p class="sub-heading">On Board the tanker</p>
                    <p class="sub-heading">#OnBoardthetanker#</p>
                </div>
                <div class="col-4" style="margin-left: 50px;">
                    <p class="sub-heading">Flag</p>
                    <p class="sub-heading">#Flag#</p>
                </div>
                <div class="col-4" style="margin-left: 50px;">
                    <p class="sub-heading">Master</p>
                    <p class="sub-heading">#Master#</p>
                </div>
            </div>
            <div class="col-12">
                <hr style="background: blue;">
            </div>
            <div class="row">
                <div class="col-4">
                    <p class="sub-heading">Loaded at the port of</p>
                    <p class="sub-heading">#Loadedattheportof#</p>
                </div>
                <div class="col-4" style="margin-left: 50px;">
                    <p class="sub-heading">To be delivered to the port of</p>
                    <p class="sub-heading">#Tobedeliverdtotheportof#</p>
                </div>
                <div class="col-4" style="margin-left: 50px;">
                    <p class="sub-heading">Voyage Number</p>
                    <p class="sub-heading">#VoyageNumber#</p>
                </div>
            </div>
            <div class="col-12">
                <hr style="background: blue;">
                <p class="sub-heading" style="margin-bottom: 10px;">A Quantity in bulk said by the Shipper to be:</p>
            </div>
            <div class="row">
                <div class="col-6">
                    <p class="sub-heading">COMMODITY (Name of product)</p>
                    <p class="sub-heading">#COMMODITY#</p>
                </div>
                <div class="col-6">
                    <p class="sub-heading" style="margin-left: 50px;">QUANTITY (lbs, tonnes, barrels, gallons</p>
                    <p class="sub-heading" style="margin-left: 50px;">#Quantity#</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <p class="sub-heading">OCEAN CARRIAGE STOWAGE: 3P,3S,4P,45, 6P, 6S, SLOP P AND SLOP S</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 20px;">
                    <p class="sub-heading">This shipment of 
                        <span> #Quantity# </span> 
                        Metrie tons was loaded on board the Vessel as part of one original lot of 
                        <span> #VesselBlNumbers# </span>
                        Metrie tons stowed in 
                        <span> #SLOP S# </span> 
                        with no segregation as to parcels. For the whole shipment 
                        <span> #TotalBlNumbers# </span> 
                        set
                        Of Bill of Lading have been issued for which the Vessel is relieved from all responsibilities to the extent it would be if one sel only would have been issued. The Vessel
                        undertakes to deliver only that portion of the cargo actually loaded which is represented by the percentage that the total amount specifed in the Bill(s) of Lading bears to the
                        foal of the commingling shipment delivered at destination. Neither the Vessel nor the overs assume any responsibility for the consequences of such commingling nor for the
                        separation thereof at the time of delivery. </p>

                        <p class="sub-heading" style="margin-top: 10px;">The quantity, measurement, weight, gauge, quality, nature and value and actual condilion of the cargo unknorm to the Vessel and the Maser, lo be delivered to the port of
                        discharge or so near there to as the Vessel can safely get, always a float upon prior payment of freight as agreed. Cargo is warranted free of danger to Vessel except for the
                        usual risks inherent in the carriage of the commodity as described.</p>

                        <p class="sub-heading" style="margin-top: 10px;">This shipment is carried under and pursuant to the forms of the Charter daled 
                        <span> #SwitchBlInvoiceDate# </span> 
                        Between
                        <span> AS PER CHARTER PARTY </span> 
                        As Owners and
                        <span> AS PER CHARTER PARTY </span>
                        As Charterers, and all conditions. Liberties
                        And exception whatsoever of the said Charier apply to and govern the rights of the parties concerned in this shipment. The Clause Paramount, New Jason Clause and Both
                        to Blame Collision Clause as set out on the reverse of this Bill of Lading are hereby incorpornled herein and shall remain in effect even if unenforceable in the United States of
                        America, General Average payment according to the York-Antwerp Rules 1974, as amended 1994.</p>
                        <p class="sub-heading">The Master is authorized to act for all interests in arranging for salvage assistance on lerms of Lloyds Open Form. The freight is payable discountless and is earned
                        concurrent with loading, ship and/or cargo lost or not lost or abandoned. </p>

                        <p class="sub-heading">The Overs shall have an absolute lien on he cargo for all freight. Deadfreight, demurrage, damages for detention and all other monies due under the above mentioned
                        Charter or under this Bill of Lading, logether with the costs and expenses, including attorneys fees, of recovering same, and shall be antitled to sell or otherwise dispose of the
                        property lined and apply the proceeds towards satisfaction of such liability.</p>

                        <p class="sub-heading" style="margin-top: 10px;">The contract of carriage evidenced by this Bill of Lading is between the shipper, consignee and/or over of the cargo and the owner or demise charterers of the Vessel named
                        herein to carry the cargo described above,</p>

                        <p class="sub-heading">carrior or baile of said shipment or under any responsibility with respect thereto, all limitations af or exonerations from liability and all defences provided by law or by the terms
                        of the contract of carriage shall be available to such other</p>

                        <p class="sub-heading" style="margin-top: 10px;">All of he provisions written, printed or stamped on either side hereof are part of this Bill of Lading Contract.
                        In Witness Whereof, the master has signed 
                        <span> #3 (THREE) ORIGINALS# </span>
                        Bills of Lading of this tenor and date, one of which being accomplished, the others will be void.</p>

                        <p class="sub-heading">Dated at 
                        <span> INDONESIA </span> 
                        this
                        <span> #SignedDay# </span>
                        day of
                        <span> #SignedMonth# </span> 
                        
                        <span> #SignedYear# </span></p>
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
            <div class="row">
                <div class="col-12" style="margin-top: 60px;">
                    <p class="sub-heading" style="font-weight: bolder;">BILL OF LANDING</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 5px;">
                    <p class="sub-heading">TO BE USED WITH CHARTER-PARTIES</p>
                </div>
            </div>
            <div class="row">
                <div class="col-6"></div>
                <div class="col-6">
                    <p class="sub-heading">Conditions of Carriage</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading"><h5>(1) Ceneral Paramount Clause</h5></p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(a) The Hague Rules contained in the International Convention for the Unification of certain rules relating to Bills of Landing, dated Brussels the 25%
                    August 1924 as enncted in the country of shipment, shall apply to this Bill of Landing When no such enactment is in force the country of shipment. the
                    corresponding legislation of the country of destination shall apply, but in respect of shipments to which no such enactments are compulsorily applicable,
                    the terms of the said Convention shall apply.</p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(b) Trades where Hauge-Visby Rules apply.
                    In trades where the International Brussels Convention 1924 as amended by the Protocol signed at Brussels on February 23 196&- the Hague-Visby
                    Rules-apply compulsorily, the provisions of the respective legislation shall apply to this Bill of Landing</p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(c)  The Carrier shall in no case be responsible for the loss of or damage to the cargo, howsoever arising prior to loading into and affer discharge from the
                    Vessel or while the cargo is in the charge of another Carrier, nor in respect of deck cargo or live animals.</p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">(d) If the carriage covered by this Bill of Landing includes Carriage to or from a port or place in the United States of America, this Bill of Landing shall be
                    subject to the United States Carriage of Goods by Sea Act 1939 (US COGS A), the terms of which are incorporated herein and shall govern throughout
                    the entire Carriage set forth in this Bill of Landing Neither the Hague or Hague-Visby Rules shall apply to the Carriage to or from the United States.
                    The Carrier shall be entitled to the benefits of the defenses and limitations in US COGSA. whether the loss or damage to the Goods occurs at sea or not.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading"><h5>(2) General Average</h5></p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">General Average shall be adjusted, stated and settled according to York-Antwerp Rules 1994, or any subsequent modification thereof, in London unless
                    another place is agreed in the Charter Party. Cargos contribution to General Avcrage shall be paid to the Carrier even when such average is the result of a
                    fault, neglect or error of the Master, Pilot or Crew. The Charterers, Shippers, Consignees and the Holder of this Bill of Landing expressly renounce the Belgian
                    Commercial Code, Part II. Art. 148,</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading"><h5>(3) New Jason Clause</h5></p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">In the event of accident, danger, or disaster before or after the commencement of the voyage, resulting from any cause whatsoever, whether due to negligence
                    or not, for which or for the consequence of which, the Carrier is not responsible, by statute, contract or otherwise, the cargo, Shippers, Cosignees, the Owners
                    of the cargo or the Holder of this Bill of Landing shall contribute with the Carrier in General Average to the payment of any sacrifices, losses or expenses of a
                    General Average nature that may be made or incurred and shall pay salvage and special charges incurred in respect of the cargo. If a salving vessel, is owned
                    or operated by the Carrier, salvage shall be paid for as fully as if the said salving vessel or vessels belonged to strangers. Such deposit as the Carrier, or his
                    agents, may deem suflicient to cover the estimated contribution of the goods and any salvage and special charges thereon shall, if required, be made by the
                    cargo, Shippers, Consignces or Owners of the goods or Holder of this Bill of Landing to the Carrier before delivery.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading"><h5>(4) Both-to-Blame Collision Clause</h5></p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">If the Vessel comes into collision with another vessel as a result of the negligence of the other vessel and any act, neglect or default of the Master, Mariner.
                    Pilot or the servants of the Carrier in the navigation or in the management of the Vessel, the owners of the cargo carried hereunder and the Holder of this Bill of
                    Landing will indemnify the Carrier against all loss of liability to the other or non-carrying vessel or her owners in so far as such loss or liability represents loss
                    of, or damage to, or any claim whatsoever of the owners of said cargo, paid or payable by the vessel or her owners as part of their claim against the carrying
                    Vessel or the Carrier.
                    The foregoing provisions shall also apply where the owners, operators or those in charge of any vessel or vessels or objects other than, or in addition to, the
                    colliding vessels or objects are at fault in respect of a collision or contact.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading"><h5>(5) Notice of Loss or Damage to the Goods</h5></p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">Unless Notice of Loss or Damage to the Goods and the general nature of such loss or damage be given in writing to the Carrier or his agent at the port of
                    discharge before or at the time of the removal of the goods into the custody of the person entitled to delivery thereof under the contract of carriage, or, if the
                    loss or damage be not apparent within 3 (three) days, such removal shall be prima facie evidence of the delivary by the carrier of the goods as described in the
                    bill or landing (Hague-Visby Rules Article Ill Rule 6)</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading"><h5>(6) Time Bar</h5></p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">All liability whatsoever of the Carrier shall cease unless suit is brought within 1 (one) year after delivery of the goods or the date when the goods should have
                    been delivered,</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading"><h5>(7) Cargo loss</h5></p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">The Carrier shall not be liabla for any short outturn cargo quantity below 0.5% as determined by the discrepancy between the quantity of cargo received
                    onboard the vessel in Port of Loading and the ships ligure in Port of Discharge</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading"><h5>(8) Limitation of Liability</h5></p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">The Carrier shall have the benefit of all applicable imitations of an exemptions from liability accorded to the Carrier by any laws, statues, or regulations of any
                    country for the time being in force notwithstanding any provision of the charterparty</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <p class="sub-heading"><h5>(9) Himalaya Cargo Clause</h5></p>
                    <p class="sub-heading" style="margin-left: 20px; margin-bottom: 10px;">It is hereby expressly agreed that no servant or agent of the Carrier (including every independent contractor from time to time employed by the Carrier) shall in
                    any circumstances whatsoever be under any liability to the shipper. Consignce or owner of the cargo or to any Holder of this Bill of Landing for any loss,
                    damage or delay of whatsoever kind arising or resulting directly or indirectly from any act, neglect or default on his part while acting in the course of or in
                    connection with his employment and, but without prejudice to generality of the foregoing provisions in this Clause, every exemption, limitation, condition and
                    liberty herein contained and every right, exemption from liability, defense and immunity of whatsoever nature applicable to the Carrier or to which the Carrier
                    is entitled hereunder shall also be available and shall extend to protect every such servant pr agent of the Carrior acting as aforesaid and for the purpose of all
                    the foregoing provisions of the Clause the Carrier is or shall be deemed to be acting as agent or trustee on behalf of and for the benefit of all persons who are or
                    might be his servants or agent from time to time (including independent contractions as aforesaid) and all such-persons shall to this extent be or be deemed to
                    be parties to the contract in or evidenced by this Bill of Landing
                    The Carrier shall be entitled to be paid by the Shipper. Consignee, owner of the cargo and or Holder of the Bill of Landing (who shall be jointly and severally
                    liable to the carrier therefore) on demand any sum recovered or recoverable by either such Shipper, Consignes, owner of the cargo and or Holder of the Bill of
                    Landing or any other from such servant or agent of the Carrier for any such loss, damage, delay or otherwise.</p>
                </div>
            </div>
            <div class="row">
                <div class="col-12" style="margin-top: 10px;">
                    <p class="sub-heading">All terms and conditions, liberties and exceptions of the BIMCO War Risk Clause for Time
                    Charters,</p>
                    <p class="sub-heading">2004 (Codename: Conwartime 2004) and amendments thereto are herewith incorporated.</p>
                </div>
            </div>
        </div>    
    </div>      
</body>
</html>' WHERE EmailTemplateName ='SwitchBlPdfGenerationTemplate'
END
GO