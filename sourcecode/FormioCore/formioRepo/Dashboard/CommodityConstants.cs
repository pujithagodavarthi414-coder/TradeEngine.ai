using Microsoft.Extensions.Configuration;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioRepo.Dashboard
{
    public class CommodityConstants
    {
        public class Commodity
        {
            public string Name { get; set; }
            public string NameLower => Name.ToLower();
            public string NameKey => Name.Replace(" ", "-").ToLower();
            public int Order { get; set; }
            public string DisplayName { get; set; }
        }
        public class PositionAndCommodity
        {
            public double Id { get; set; }
            public double ParentId { get; set; }
            public string Position { get; set; }
            public string Name { get; set; }
            public string ProductGroup { get; set; }
            public string NameLower => Name?.ToLower();
            public string NameKey => Name?.Replace(" ", "-").ToLower();
            public decimal Order { get; set; }
            public string DisplayName { get; set; }
            public string CompanyName { get; set; }
            public bool IsGroupBy { get; set; }
        }

        public static readonly Dictionary<string, List<Commodity>> CommodityGroups
            = new Dictionary<string, List<Commodity>>
        {
            { "PAndL", new List<Commodity>
                {
                    new Commodity { Name = "DUTY", Order = 1, DisplayName = "Duty" },
                    new Commodity { Name = "FX-PAYMENT-PURCHASE", Order = 2, DisplayName = "FX Payment (Purchase)" },
                    new Commodity { Name = "REFINING-COST", Order = 3, DisplayName = "Refining + CNF Charges" },
                    new Commodity { Name = "CNF-CHARGES", Order = 4, DisplayName = "CNF Charges" },
                    new Commodity { Name = "PAYMENT-PURCHASE", Order = 5, DisplayName = "PAYMENT (PURCHASE)" },
                    new Commodity { Name = "P&L-INR", Order = 6, DisplayName = "P&L (INR)" },
                    new Commodity { Name = "P&L-USD", Order = 7, DisplayName = "P&L (USD)" }
                }
            },
            {
                "CPO", new List<Commodity>
                {
                    new Commodity { Name = "CPO", Order = 0, DisplayName = "CPO" },
                    new Commodity { Name = "CPO-Ex-Tank", Order = 1, DisplayName = "CPO (Ex-Tank)" },
                    new Commodity { Name = "RBD PALM OLEIN", Order = 2, DisplayName = "RBD Palm Olein" },
                    new Commodity { Name = "REFINED PALM OIL", Order = 3, DisplayName = "Refined Palm Oil" },
                    new Commodity { Name = "STEARIN", Order = 4, DisplayName = "Stearin" },
                    new Commodity { Name = "HARD STEARIN", Order = 5, DisplayName = "Hard Stearin" },
                    new Commodity { Name = "SOFT STEARIN", Order = 6, DisplayName = "Soft Stearin" },
                    new Commodity { Name = "PFAD", Order = 7, DisplayName = "PFAD" },
                    new Commodity { Name = "WHITE OLEIN", Order = 8, DisplayName = "White Olein" },
                    new Commodity { Name = "CALCIUM SOAP", Order = 9, DisplayName = "Calcium Soap" },
                    new Commodity { Name = "Loss", Order = 10, DisplayName = "Loss" }
                }
            },
            { "RBD PALM OLEIN-TRADING", new List<Commodity>
                {
                    new Commodity { Name = "RBD PALM OLEIN-TRADING", Order = 0, DisplayName = "RBD Palm Olein (Trading)" },
                    new Commodity { Name = "RBD PALM OLEIN-Ex-Tank", Order = 1, DisplayName = "RBD Palm Olein (Ex-Tank)" },
                }
            },
            { "REFINED PALM OIL-TRADING", new List<Commodity>
                {
                    new Commodity { Name = "REFINED PALM OIL-TRADING", Order = 0, DisplayName = "Refined Palm Oil (Trading)" },
                    new Commodity { Name = "REFINED PALM OIL-Ex-Tank", Order = 1, DisplayName = "Refined Palm Oil (Ex-Tank)" },
                }
            },
            { "CSFO", new List<Commodity>
                {
                    new Commodity { Name = "CSFO", Order = 0, DisplayName = "CSFO" },
                    new Commodity { Name = "CSFO-Ex-Tank", Order = 1, DisplayName = "CSFO (Ex-Tank)" },
                    new Commodity { Name = "RSFO", Order = 2, DisplayName = "RSFO" },
                    new Commodity { Name = "SUNFLOWER FATTY ACID", Order = 3, DisplayName = "Sunflower Fatty Acid" },
                    new Commodity { Name = "Loss", Order = 4, DisplayName = "Loss" },
                }
            },
            { "RSFO-TRADING", new List<Commodity>
                {
                    new Commodity { Name = "RSFO-TRADING", Order = 0, DisplayName = "RSFO (Trading)" },
                    new Commodity { Name = "RSFO-Ex-Tank", Order = 1, DisplayName = "RSFO (Ex-Tank)" }
                }
            },
            { "CRBO", new List<Commodity>
                {
                    new Commodity { Name = "CRBO", Order = 0, DisplayName = "CRBO" },
                    new Commodity { Name = "CRBO-Ex-Tank", Order = 1, DisplayName = "CRBO (Ex-Tank)" },
                    new Commodity { Name = "RRBO", Order = 2, DisplayName = "RRBO" },
                    new Commodity { Name = "RB FATTY ACID", Order = 3, DisplayName = "RB Fatty Acid" },
                    new Commodity { Name = "RB OIL WAX", Order = 4, DisplayName = "RB Oil Wax" },
                    new Commodity { Name = "Loss", Order = 5, DisplayName = "Loss" }
                }
            },
            { "RRBO-TRADING", new List<Commodity>
                {
                    new Commodity { Name = "RRBO-TRADING", Order = 0, DisplayName = "RRBO (Trading)" },
                    new Commodity { Name = "RRBO-Ex-Tank", Order = 1, DisplayName = "RRBO (Ex-Tank)" }
                }
            },
            { "CDSBO", new List<Commodity>
                {
                    new Commodity { Name = "CDSBO", Order = 0, DisplayName = "CDSBO" },
                    new Commodity { Name = "CDSBO-Ex-Tank", Order = 1, DisplayName = "CDSBO (Ex-Tank)" },
                    new Commodity { Name = "RSBO", Order = 2, DisplayName = "RSBO" },
                    new Commodity { Name = "SOY ACID OIL", Order = 3, DisplayName = "Soy Acid Oil" },
                    new Commodity { Name = "Loss", Order = 4, DisplayName = "Loss" }
                }
            },
            { "RSBO-TRADING", new List<Commodity>
                {
                    new Commodity { Name = "RSBO-TRADING", Order = 0, DisplayName = "RSBO (Trading)" },
                    new Commodity { Name = "RSBO-Ex-Tank", Order = 1, DisplayName = "RSBO (Ex-Tank)" }
                }
            },
            { "CRUDE GLYCERIN", new List<Commodity>
                {
                    new Commodity { Name = "CRUDE GLYCERIN", Order = 0, DisplayName = "Crude Glycerin" },
                    new Commodity { Name = "CRUDE GLYCERIN-Ex-Tank", Order = 1, DisplayName = "Crude Glycerin (Ex-Tank)" },
                    new Commodity { Name = "REFINED GLYCERIN", Order = 2, DisplayName = "Refined Glycerin" },
                    new Commodity { Name = "Loss", Order = 3, DisplayName = "Loss" },
                }
            },
            { "REFINED GLYCERIN-TRADING", new List<Commodity>
                {
                    new Commodity { Name = "REFINED GLYCERIN-TRADING", Order = 0, DisplayName = "Refined Glycerin (Trading)" },
                    new Commodity { Name = "REFINED GLYCERIN-Ex-Tank", Order = 1, DisplayName = "Refined Glycerin (Ex-Tank)" }
                }
            },
            // Add more groups as needed
        };

        //Need to main in lower case for Ids
        public static readonly Dictionary<string, string> SalesFormIds = new Dictionary<string, string>
        {
            { "ANA-KAKINADA","bae0b939-6e5f-4291-8892-30bd1823b0cd" },
            { "ANA-KANDLA", "c58946f2-215e-462a-962f-8c7ec3017257" },
            { "Umiro-INDIA", "f92678f3-0aed-418b-963d-4ec29bf98f1d" },
            { "ANA-KRISHNAPATNAM", "e99919ea-d36b-469b-99da-3d1d9823e2f6" },
            { "ANA-MANGALORE", "a0dfd197-45c5-4344-b736-645102ab778a" },
            { "ANA-CHENNAI", "48ad8f08-9ae5-4009-a4c4-2c2d33e9bb89" },
            { "SG-ANA", "3c4abdbd-36f6-486c-937a-48f31b2502cd" },
            { "SG-ORIMU", "3c4abdbd-36f6-486c-937a-48f31b2502cd" },
            { "ANA-MUMBAI", "53839149-0623-442a-a6bf-fd846db70e5b" },
        };

        //Need to main in lower case for Ids
        public static readonly Dictionary<string, string> PurchaseFormIds = new Dictionary<string, string>
        {
            { "ANA-KAKINADA", "c201551e-8804-4025-95a6-90783b64f69b" },
            { "ANA-KANDLA", "d87ea5af-aa5d-4499-a84e-8d1094170e01" },
            { "Umiro-INDIA", "72e023c9-ff29-4e6f-ae71-8670769c81e6" },
            { "ANA-KRISHNAPATNAM", "0122470e-ba5f-4d33-8aee-cf6ffa386fe4" },
            { "ANA-MANGALORE", "8435be4c-bbfb-4aac-b2b5-81d0204c6f7c" },
            { "ANA-CHENNAI", "f3d2f93e-0f15-4698-be40-9d0b5a4fafb1" },
            { "SG-ANA", "47a81d57-1e7e-41f0-8e2f-57adad77e681" },
            { "SG-ORIMU", "69d8ca1a-cd92-48cf-8b66-6c42c7948253" },
            { "ANA-MUMBAI", "c67d3ede-c97e-4672-b10a-c87ff3e3cf15" },
        };

        //Need to maintain in lower case for Ids
        public static readonly Dictionary<string, string> CustomsDutyFormIds = new Dictionary<string, string>
        {
            { "ANA-KAKINADA", "ffda40c1-d4e6-491b-a40d-9a1837ef337b" },
            { "ANA-KANDLA", "d1e8b4c9-b1b5-4349-828c-536d48e74093" },
            { "Umiro-INDIA", "10f8c428-bd47-4dae-8e99-ca95d5a63e68" },
            { "ANA-KRISHNAPATNAM", "6f45b932-0e7f-433a-bbdb-ae284715c957" },
            { "ANA-MANGALORE", "35c40cf0-681b-46f4-bc96-eb50219ece25" },
            { "ANA-CHENNAI", "5cee7fe4-2891-4bb4-9a37-c9b473f74c46" },
            { "ANA-MUMBAI", "2b5cc22c-4d9f-41a7-a37d-2d3a63d017ce" },
        };

        public static readonly Dictionary<string, string> Companies = new Dictionary<string, string>
        {
            {"ANA+Umiro", "326f3498-489e-4105-bd58-618659ae1a25"},
            {"ANA-CHENNAI", "e988dfeb-ccbf-4209-b8da-36e5779bb506" },
            {"ANA-KAKINADA", "c257e881-96ce-46c0-9b02-0aa18edc6004" },
            { "ANA-KANDLA",  "406895a5-a90b-4d84-a3c5-dde1c1e139ef" },
            { "ANA-MANGALORE",  "f4ed2690-5b97-40b5-9247-b5e91bee7641" },
            { "ANA-KRISHNAPATNAM",  "7ce6aeec-bd38-4951-9949-16a58a432aa8" },
            { "ANA-MUMBAI",  "10afd1a0-dc0f-458b-8639-91794309879b" },
            { "SG-ANA",  "4cf4f4b2-431d-47f4-b364-88ca1a7760c6" },
            { "Umiro-INDIA",  "81ad93d0-05c2-49d5-9c20-16779edf2ca7" }
        };

        public static string DailyRatesFormId = "2dd458e8-af57-4f85-bc3d-cffafabbfcf1"; //Ana+Umiro Daily Rates Form
        public static string DutyFormId = "a971c5c8-ce7a-4640-b2ae-0348e005b9d9"; //Ana+Umiro Duty Form
        public static string FXPaymentsANAFormId = "dca15a7d-ff5f-4b73-aaf7-80d069923815"; //FX Payments-ana-INDIA Form
        public static string FXPaymentsUmiroFormId = "8aad163a-ab9c-4890-a446-9f2ffa6d29ba"; //FX-PAYMENTS-UMIRO-INDIA Form
        public static string LocationMasterFormId = "fae1b91d-f036-45c7-98e4-e0e6c0ab7ffe"; //ANA+Umiro Location Master Form
        public static string OpeningBalanceFormId = "138a84fa-b720-4650-9172-0227b9209bf3"; //ANA+UMIRO Opening Balance Form
        public static string UmiroCompanyId = "326f3498-489e-4105-bd58-618659ae1a25"; //UmiroCompanyId
        public static string UmiroAdjFormId = "e5e95cec-ddcc-42ec-9c2d-43a3ba741fcb"; //ANA+UMIRO CANCELLATIONS/ADJUSTMENT-UMIRO
        public static string ANAAdjFormId = "59ea12a8-a038-43ca-8921-a942578e5a40"; //ANA+UMIRO CANCELLATIONS/ADJUSTMENTS-ANA-INDIA
        public static string FO_BuyFormId = "3d6d5a51-555b-4d33-8051-ff7e0d54132b"; //SG-ANA F & O_BUY-New Form
        public static string FO_SellFormId = "ec5dc8ed-e9f8-4b84-8364-17f998f9354f"; //SG-ANA F & O_SELL-New Form
        public static string SGVCFormId = "d8d4888f-6d33-428a-956c-24e937397f3c"; //SG-ANA SG VESSEL-CONTRACT PURCHASE form
        public static string SGTBAPFormId = "47a81d57-1e7e-41f0-8e2f-57adad77e681"; //SG-ANA TBA PURCHASE-ANA Form
        public static string OrimuTBAPFormId = "69d8ca1a-cd92-48cf-8b66-6c42c7948253"; //SG-ANA TBA PURCHASE-ORIMU Form
        public static string SGSalesFormId = "3c4abdbd-36f6-486c-937a-48f31b2502cd"; //SG-ANA SG SALES Form
        public static string FO_DailyRatesFormId = "0cceb812-65c8-406f-aa4d-70ead11f1e01"; //SG-ANA F & O Daily Rates Form
        
        public static List<PositionAndCommodity> PositionCommodities = new List<PositionAndCommodity>
        {
            new PositionAndCommodity { Id=1,ParentId=0,Position = "ANA INDIA PHYSICAL (TOLLING)",Order = 1,DisplayName = "Ana India Physical (Tolling)",IsGroupBy = true },
            
            new PositionAndCommodity { Id=2,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "CPO",ProductGroup="PALM OIL",Order = 2,DisplayName = "CPO",IsGroupBy = false },
            
            new PositionAndCommodity { Id=2.1,ParentId=2,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "CPO-Ex-Tank",Order = 1,DisplayName = "CPO (Ex-Tank)",IsGroupBy = false },
            new PositionAndCommodity { Id=2.2,ParentId=2,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "RBD PALM OLEIN",Order = 2,DisplayName = "RBD Palm Olein",IsGroupBy = false },
            new PositionAndCommodity { Id=2.3,ParentId=2,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "REFINED PALM OIL",Order = 3,DisplayName = "Refined Palm Oil",IsGroupBy = false },
            new PositionAndCommodity { Id=2.4,ParentId=2,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "STEARIN",Order = 4,DisplayName = "Stearin",IsGroupBy = false },
            new PositionAndCommodity { Id=2.5,ParentId=2,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "HARD STEARIN",Order = 5,DisplayName = "Hard Stearin",IsGroupBy = false },
            new PositionAndCommodity { Id=2.6,ParentId=2,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "SOFT STEARIN",Order = 6,DisplayName = "Soft Stearin",IsGroupBy = false },
            new PositionAndCommodity { Id=2.7,ParentId=2,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "PFAD",Order = 7,DisplayName = "PFAD",IsGroupBy = false },
            new PositionAndCommodity { Id=2.8,ParentId=2,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "CALCIUM SOAP",Order = 8,DisplayName = "Calcium Soap",IsGroupBy = false },
            new PositionAndCommodity { Id=2.9,ParentId=2,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "Loss",Order = 9,DisplayName = "Loss",IsGroupBy = false },
            new PositionAndCommodity { Id=2.9,ParentId=2,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "Cancellation",Order = 10,DisplayName = "Cancellation/Yield adj",IsGroupBy = false },

            new PositionAndCommodity { Id=3,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "CSFO",ProductGroup="SUNFLOWER OIL",Order = 3,DisplayName = "CSFO",IsGroupBy = false },

            new PositionAndCommodity { Id=3.1,ParentId=3,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "CSFO-Ex-Tank",Order = 1,DisplayName = "CSFO (Ex-Tank)",IsGroupBy = false },
            new PositionAndCommodity { Id=3.2,ParentId=3,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "RSFO",Order = 2,DisplayName = "RSFO",IsGroupBy = false },
            new PositionAndCommodity { Id=3.3,ParentId=3,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "SUNFLOWER FATTY ACID",Order = 3,DisplayName = "Sunflower Fatty Acid",IsGroupBy = false },
            new PositionAndCommodity { Id=3.4,ParentId=3,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "Loss",Order = 4,DisplayName = "Loss",IsGroupBy = false },
            new PositionAndCommodity { Id=3.5,ParentId=3,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "Cancellation",Order = 5,DisplayName = "Cancellation/Yield adj",IsGroupBy = false },

            new PositionAndCommodity { Id=4,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "CRBO",ProductGroup="RICE BRAN OIL",Order = 4,DisplayName = "CRBO",IsGroupBy = false },

            new PositionAndCommodity { Id=4.1,ParentId=4,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "CRBO-Ex-Tank",Order = 1,DisplayName = "CRBO (Ex-Tank)",IsGroupBy = false },
            new PositionAndCommodity { Id=4.2,ParentId=4,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "RRBO",Order = 2,DisplayName = "RRBO",IsGroupBy = false },
            new PositionAndCommodity { Id=4.3,ParentId=4,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "RB FATTY ACID",Order = 3,DisplayName = "RB Fatty Acid",IsGroupBy = false },
            new PositionAndCommodity { Id=4.4,ParentId=4,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "RB OIL WAX",Order = 4,DisplayName = "RB Oil Wax",IsGroupBy = false },
            new PositionAndCommodity { Id=4.5,ParentId=4,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "Loss",Order = 5,DisplayName = "Loss",IsGroupBy = false },
            new PositionAndCommodity { Id=4.6,ParentId=4,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "Cancellation",Order = 6,DisplayName = "Cancellation/Yield adj",IsGroupBy = false },

            new PositionAndCommodity { Id=5,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "CDSBO",ProductGroup="SOYABEAN OIL",Order = 5,DisplayName = "CDSBO",IsGroupBy = false },

            new PositionAndCommodity { Id=5.1,ParentId=5,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "CDSBO-Ex-Tank",Order = 1,DisplayName = "CDSBO (Ex-Tank)",IsGroupBy = false },
            new PositionAndCommodity { Id=5.2,ParentId=5,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "RSBO",Order = 2,DisplayName = "RSBO",IsGroupBy = false },
            new PositionAndCommodity { Id=5.3,ParentId=5,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "SOY ACID OIL",Order = 3,DisplayName = "Soy Acid Oil",IsGroupBy = false },
            new PositionAndCommodity { Id=5.4,ParentId=5,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "Loss",Order = 4,DisplayName = "Loss",IsGroupBy = false },
            new PositionAndCommodity { Id=5.5,ParentId=5,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "Cancellation",Order = 5,DisplayName = "Cancellation/Yield adj",IsGroupBy = false },

            new PositionAndCommodity { Id=6,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "CRUDE GLYCERIN",ProductGroup="GLYCERIN",Order = 6,DisplayName = "Crude Glycerin",IsGroupBy = false },

            new PositionAndCommodity { Id=6.1,ParentId=6,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "CRUDE GLYCERIN-Ex-Tank",Order = 1,DisplayName = "Crude Glycerin (Ex-Tank)",IsGroupBy = false },
            new PositionAndCommodity { Id=6.2,ParentId=6,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "REFINED GLYCERIN",Order = 2,DisplayName = "Refined Glycerin",IsGroupBy = false },
            new PositionAndCommodity { Id=6.3,ParentId=6,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "Loss",Order = 3,DisplayName = "Loss",IsGroupBy = false },
            new PositionAndCommodity { Id=6.4,ParentId=6,Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "Cancellation",Order = 4,DisplayName = "Cancellation/Yield adj",IsGroupBy = false },

            new PositionAndCommodity { Id=7,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TOLLING)",Name = "SUB TOTAL",Order = 7,DisplayName = "Sub Total",IsGroupBy = false },

            new PositionAndCommodity { Id=8,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TRADING)",Order = 8,DisplayName = "Ana India Physical (Trading)",IsGroupBy = true },

            new PositionAndCommodity { Id=9,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TRADING)",Name = "RBD PALM OLEIN-TRADING",Order = 9,DisplayName = "RBD Palm Olein (Trading)",IsGroupBy = false },
            
            new PositionAndCommodity { Id=9.1,ParentId=9,Position = "ANA INDIA PHYSICAL (TRADING)",Name = "RBD PALM OLEIN-Ex-Tank",Order = 1,DisplayName = "RBD Palm Olein (Ex-Tank)",IsGroupBy = false },

            new PositionAndCommodity { Id=10,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TRADING)",Name = "REFINED PALM OIL-TRADING",Order = 10,DisplayName = "Refined Palm Oil (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=10.1,ParentId=10,Position = "ANA INDIA PHYSICAL (TRADING)",Name = "REFINED PALM OIL-Ex-Tank",Order = 1,DisplayName = "Refined Palm Oil (Ex-Tank)",IsGroupBy = false },
            
            new PositionAndCommodity { Id=11,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TRADING)",Name = "RSFO-TRADING",Order = 11,DisplayName = "RSFO (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=11.1,ParentId=11,Position = "ANA INDIA PHYSICAL (TRADING)",Name = "RSFO-Ex-Tank",Order = 1,DisplayName = "RSFO (Ex-Tank)",IsGroupBy = false },

            new PositionAndCommodity { Id=12,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TRADING)",Name = "RRBO-TRADING",Order = 12,DisplayName = "RRBO (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=12.1,ParentId=12,Position = "ANA INDIA PHYSICAL (TRADING)",Name = "RRBO-Ex-Tank",Order = 1,DisplayName = "RRBO (Ex-Tank)",IsGroupBy = false },

            new PositionAndCommodity { Id=13,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TRADING)",Name = "RSBO-TRADING",Order = 13,DisplayName = "RSBO (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=13.1,ParentId=13,Position = "ANA INDIA PHYSICAL (TRADING)",Name = "RSBO-Ex-Tank",Order = 1,DisplayName = "RSBO (Ex-Tank)",IsGroupBy = false },

            new PositionAndCommodity { Id=14,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TRADING)",Name = "REFINED GLYCERIN-TRADING",Order = 14,DisplayName = "Refined Glycerin (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=14.1,ParentId=14,Position = "ANA INDIA PHYSICAL (TRADING)",Name = "REFINED GLYCERIN-Ex-Tank",Order = 1,DisplayName = "Refined Glycerin (Ex-Tank)",IsGroupBy = false },
            
            new PositionAndCommodity { Id=15,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA PHYSICAL (TRADING)",Name = "SUB TOTAL",Order = 15,DisplayName = "Sub Total",IsGroupBy = false },

            new PositionAndCommodity { Id=16,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Order = 16,DisplayName = "Paper & Futures",IsGroupBy = true },
            new PositionAndCommodity { Id=17,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Name = "PKPG-RBD PALM OLEIN",Order = 17,DisplayName = "PKPG (RBD Palm Olein)",IsGroupBy = false },
            new PositionAndCommodity { Id=18,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Name = "PKPG-CPO",Order = 17,DisplayName = "PKPG (CPO)",IsGroupBy = false },
            new PositionAndCommodity { Id=19,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Name = "PKPG-CSFO",Order = 17,DisplayName = "PKPG (CSFO)",IsGroupBy = false },
            new PositionAndCommodity { Id=20,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Name = "PKPG-CRBO",Order = 17,DisplayName = "PKPG (CRBO)",IsGroupBy = false },
            new PositionAndCommodity { Id=21,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Name = "PKPG-CDSBO",Order = 17,DisplayName = "PKPG (CDSBO)",IsGroupBy = false },
            new PositionAndCommodity { Id=22,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Name = "PKPG-CRUDE GLYCERIN",Order = 17,DisplayName = "PKPG (CRUDE GLYCERIN)",IsGroupBy = false },
            new PositionAndCommodity { Id=23,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Name = "MDEX-CPO",Order = 18,DisplayName = "MDEX (CPO)",IsGroupBy = false },
            new PositionAndCommodity { Id=24,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Name = "MDEX-RBD PALM OLEIN",Order = 18,DisplayName = "MDEX (RBD Palm Olein)",IsGroupBy = false },
            new PositionAndCommodity { Id=25,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Name = "MDEX-CSFO",Order = 18,DisplayName = "MDEX (CSFO)",IsGroupBy = false },
            new PositionAndCommodity { Id=26,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Name = "MDEX-CRBO",Order = 18,DisplayName = "MDEX (CRBO)",IsGroupBy = false },
            new PositionAndCommodity { Id=27,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Name = "MDEX-CDSBO",Order = 18,DisplayName = "MDEX (CDSBO)",IsGroupBy = false },
            new PositionAndCommodity { Id=28,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Name = "MDEX-CRUDE GLYCERIN",Order = 18,DisplayName = "MDEX (CRUDE GLYCERIN)",IsGroupBy = false },
            new PositionAndCommodity { Id=29,ParentId=0,CompanyName = "ANA-INDIA",Position = "PAPER & FUTURES",Name = "SUB TOTAL",Order = 19,DisplayName = "Sub Total",IsGroupBy = false },

            new PositionAndCommodity { Id=30,ParentId=0,CompanyName = "ANA-INDIA",Position = "ANA INDIA",Order = 20,Name = "Ana India-Total" ,DisplayName = "Ana India-Total",IsGroupBy = false },
            
            //--------//

            new PositionAndCommodity { Id=31,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TOLLING)",Order = 22,DisplayName = "Umiro India Physical (Tolling)",IsGroupBy = true },

            new PositionAndCommodity { Id=32,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "CPO",ProductGroup="PALM OIL",Order = 23,DisplayName = "CPO",IsGroupBy = false },

            new PositionAndCommodity { Id=32.1,ParentId=32,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "CPO-Ex-Tank",Order = 1,DisplayName = "CPO (Ex-Tank)",IsGroupBy = false },
            new PositionAndCommodity { Id=32.2,ParentId=32,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "RBD PALM OLEIN",Order = 2,DisplayName = "RBD Palm Olein",IsGroupBy = false },
            new PositionAndCommodity { Id=32.3,ParentId=32,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "REFINED PALM OIL",Order = 3,DisplayName = "Refined Palm Oil",IsGroupBy = false },
            new PositionAndCommodity { Id=32.4,ParentId=32,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "STEARIN",Order = 4,DisplayName = "Stearin",IsGroupBy = false },
            new PositionAndCommodity { Id=32.5,ParentId=32,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "HARD STEARIN",Order = 5,DisplayName = "Hard Stearin",IsGroupBy = false },
            new PositionAndCommodity { Id=32.6,ParentId=32,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "SOFT STEARIN",Order = 6,DisplayName = "Soft Stearin",IsGroupBy = false },
            new PositionAndCommodity { Id=32.7,ParentId=32,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "PFAD",Order = 7,DisplayName = "PFAD",IsGroupBy = false },
            new PositionAndCommodity { Id=32.8,ParentId=32,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "CALCIUM SOAP",Order = 8,DisplayName = "Calcium Soap",IsGroupBy = false },
            new PositionAndCommodity { Id=32.9,ParentId=32,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "Loss",Order = 9,DisplayName = "Loss",IsGroupBy = false },
            new PositionAndCommodity { Id=32.10,ParentId=32,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "Cancellation",Order = 10,DisplayName = "Cancellation/Yield adj",IsGroupBy = false },

            new PositionAndCommodity { Id=33,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "CSFO",ProductGroup="SUNFLOWER OIL",Order = 24,DisplayName = "CSFO",IsGroupBy = false },

            new PositionAndCommodity { Id=33.1,ParentId=33,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "CSFO-Ex-Tank",Order = 1,DisplayName = "CSFO (Ex-Tank)",IsGroupBy = false },
            new PositionAndCommodity { Id=33.2,ParentId=33,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "RSFO",Order = 2,DisplayName = "RSFO",IsGroupBy = false },
            new PositionAndCommodity { Id=33.3,ParentId=33,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "SUNFLOWER FATTY ACID",Order = 3,DisplayName = "Sunflower Fatty Acid",IsGroupBy = false },
            new PositionAndCommodity { Id=33.4,ParentId=33,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "Loss",Order = 4,DisplayName = "Loss",IsGroupBy = false },
            new PositionAndCommodity { Id=33.5,ParentId=33,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "Cancellation",Order = 5,DisplayName = "Cancellation/Yield adj",IsGroupBy = false },

            new PositionAndCommodity { Id=34,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "CRBO",ProductGroup="RICE BRAN OIL",Order = 25,DisplayName = "CRBO",IsGroupBy = false },

            new PositionAndCommodity { Id=34.1,ParentId=34,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "CRBO-Ex-Tank",Order = 1,DisplayName = "CRBO (Ex-Tank)",IsGroupBy = false },
            new PositionAndCommodity { Id=34.2,ParentId=34,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "RRBO",Order = 2,DisplayName = "RRBO",IsGroupBy = false },
            new PositionAndCommodity { Id=34.3,ParentId=34,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "RB FATTY ACID",Order = 3,DisplayName = "RB Fatty Acid",IsGroupBy = false },
            new PositionAndCommodity { Id=34.4,ParentId=34,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "RB OIL WAX",Order = 4,DisplayName = "RB Oil Wax",IsGroupBy = false },
            new PositionAndCommodity { Id=34.5,ParentId=34,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "Loss",Order = 5,DisplayName = "Loss",IsGroupBy = false },
            new PositionAndCommodity { Id=34.6,ParentId=34,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "Cancellation",Order = 6,DisplayName = "Cancellation/Yield adj",IsGroupBy = false },

            new PositionAndCommodity { Id=35,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "CDSBO",ProductGroup="SOYABEAN OIL",Order = 26,DisplayName = "CDSBO",IsGroupBy = false },

            new PositionAndCommodity { Id=35.1,ParentId=35,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "CDSBO-Ex-Tank",Order = 1,DisplayName = "CDSBO (Ex-Tank)",IsGroupBy = false },
            new PositionAndCommodity { Id=35.2,ParentId=35,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "RSBO",Order = 2,DisplayName = "RSBO",IsGroupBy = false },
            new PositionAndCommodity { Id=35.3,ParentId=35,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "SOY ACID OIL",Order = 3,DisplayName = "Soy Acid Oil",IsGroupBy = false },
            new PositionAndCommodity { Id=35.4,ParentId=35,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "Loss",Order = 4,DisplayName = "Loss",IsGroupBy = false },
            new PositionAndCommodity { Id=35.5,ParentId=35,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "Cancellation",Order = 5,DisplayName = "Cancellation/Yield adj",IsGroupBy = false },

            new PositionAndCommodity { Id=36,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "CRUDE GLYCERIN",ProductGroup="GLYCERIN",Order = 27,DisplayName = "Crude Glycerin",IsGroupBy = false },

            new PositionAndCommodity { Id=36.1,ParentId=36,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "CRUDE GLYCERIN-Ex-Tank",Order = 1,DisplayName = "Crude Glycerin (Ex-Tank)",IsGroupBy = false },
            new PositionAndCommodity { Id=36.2,ParentId=36,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "REFINED GLYCERIN",Order = 2,DisplayName = "Refined Glycerin",IsGroupBy = false },
            new PositionAndCommodity { Id=36.3,ParentId=36,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "Loss",Order = 3,DisplayName = "Loss",IsGroupBy = false },
            new PositionAndCommodity { Id=36.4,ParentId=36,Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "Cancellation",Order = 4,DisplayName = "Cancellation/Yield adj",IsGroupBy = false },

            new PositionAndCommodity { Id=37,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TOLLING)",Name = "SUB TOTAL",Order = 28,DisplayName = "Sub Total",IsGroupBy = false },

            new PositionAndCommodity { Id=38,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TRADING)",Order = 29,DisplayName = "Umiro India Physical (Trading)",IsGroupBy = true },

            new PositionAndCommodity { Id=39,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TRADING)",Name = "RBD PALM OLEIN-TRADING",Order = 30,DisplayName = "RBD Palm Olein (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=39.1,ParentId=39,Position = "UMIRO INDIA PHYSICAL (TRADING)",Name = "RBD PALM OLEIN-Ex-Tank",Order = 1,DisplayName = "RBD Palm Olein (Ex-Tank)",IsGroupBy = false },

            new PositionAndCommodity { Id=40,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TRADING)",Name = "REFINED PALM OIL-TRADING",Order = 31,DisplayName = "Refined Palm Oil (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=40.1,ParentId=40,Position = "UMIRO INDIA PHYSICAL (TRADING)",Name = "REFINED PALM OIL-Ex-Tank",Order = 1,DisplayName = "Refined Palm Oil (Ex-Tank)",IsGroupBy = false },

            new PositionAndCommodity { Id=41,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TRADING)",Name = "RSFO-TRADING",Order = 32,DisplayName = "RSFO (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=41.1,ParentId=41,Position = "UMIRO INDIA PHYSICAL (TRADING)",Name = "RSFO-Ex-Tank",Order = 1,DisplayName = "RSFO (Ex-Tank)",IsGroupBy = false },

            new PositionAndCommodity { Id=42,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TRADING)",Name = "RRBO-TRADING",Order = 33,DisplayName = "RRBO (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=42.1,ParentId=42,Position = "UMIRO INDIA PHYSICAL (TRADING)",Name = "RRBO-Ex-Tank",Order = 1,DisplayName = "RRBO (Ex-Tank)",IsGroupBy = false },

            new PositionAndCommodity { Id=43,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TRADING)",Name = "RSBO-TRADING",Order = 34,DisplayName = "RSBO (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=43.1,ParentId=43,Position = "UMIRO INDIA PHYSICAL (TRADING)",Name = "RSBO-Ex-Tank",Order = 1,DisplayName = "RSBO (Ex-Tank)",IsGroupBy = false },

            new PositionAndCommodity { Id=44,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TRADING)",Name = "REFINED GLYCERIN-TRADING",Order = 35,DisplayName = "Refined Glycerin (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=44.1,ParentId=44,Position = "UMIRO INDIA PHYSICAL (TRADING)",Name = "REFINED GLYCERIN-Ex-Tank",Order = 1,DisplayName = "Refined Glycerin (Ex-Tank)",IsGroupBy = false },

            new PositionAndCommodity { Id=45,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA PHYSICAL (TRADING)",Name = "SUB TOTAL",Order = 36,DisplayName = "Sub Total",IsGroupBy = false },

            new PositionAndCommodity { Id=46,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Order = 37,DisplayName = "Paper & Futures",IsGroupBy = true },
            new PositionAndCommodity { Id=48,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Name = "PKPG-RBD PALM OLEIN",Order = 17,DisplayName = "PKPG (RBD Palm Olein)",IsGroupBy = false },
            new PositionAndCommodity { Id=49,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Name = "PKPG-CPO",Order = 17,DisplayName = "PKPG (CPO)",IsGroupBy = false },
            new PositionAndCommodity { Id=50,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Name = "PKPG-CSFO",Order = 17,DisplayName = "PKPG (CSFO)",IsGroupBy = false },
            new PositionAndCommodity { Id=51,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Name = "PKPG-CRBO",Order = 17,DisplayName = "PKPG (CRBO)",IsGroupBy = false },
            new PositionAndCommodity { Id=52,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Name = "PKPG-CDSBO",Order = 17,DisplayName = "PKPG (CDSBO)",IsGroupBy = false },
            new PositionAndCommodity { Id=53,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Name = "PKPG-CRUDE GLYCERIN",Order = 17,DisplayName = "PKPG (CRUDE GLYCERIN)",IsGroupBy = false },
            new PositionAndCommodity { Id=54,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Name = "MDEX-CPO",Order = 18,DisplayName = "MDEX (CPO)",IsGroupBy = false },
            new PositionAndCommodity { Id=55,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Name = "MDEX-RBD PALM OLEIN",Order = 18,DisplayName = "MDEX (RBD Palm Olein)",IsGroupBy = false },
            new PositionAndCommodity { Id=56,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Name = "MDEX-CSFO",Order = 18,DisplayName = "MDEX (CSFO)",IsGroupBy = false },
            new PositionAndCommodity { Id=57,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Name = "MDEX-CRBO",Order = 18,DisplayName = "MDEX (CRBO)",IsGroupBy = false },
            new PositionAndCommodity { Id=58,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Name = "MDEX-CDSBO",Order = 18,DisplayName = "MDEX (CDSBO)",IsGroupBy = false },
            new PositionAndCommodity { Id=59,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Name = "MDEX-CRUDE GLYCERIN",Order = 18,DisplayName = "MDEX (CRUDE GLYCERIN)",IsGroupBy = false },
            new PositionAndCommodity { Id=60,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "PAPER & FUTURES",Name = "SUB TOTAL",Order = 40,DisplayName = "Sub Total",IsGroupBy = false },

            new PositionAndCommodity { Id=62,ParentId=0,CompanyName = "UMIRO-INDIA",Position = "UMIRO INDIA",Name = "Umiro India-Total",Order = 41,DisplayName = "Umiro India-Total",IsGroupBy = false },

            //---------//


            new PositionAndCommodity { Id=63,ParentId=0,CompanyName = "SG-ANA",Position = "SG ANA",Order = 43,DisplayName = "SG ANA",IsGroupBy = true },

            new PositionAndCommodity { Id=64,ParentId=0,CompanyName = "SG-ANA",Position = "SG ANA",Name = "CPO",ProductGroup="PALM OIL",Order = 44,DisplayName = "CPO",IsGroupBy = false },

            new PositionAndCommodity { Id=65,ParentId=0,CompanyName = "SG-ANA",Position = "SG ANA",Name = "CSFO",ProductGroup="SUNFLOWER OIL",Order = 45,DisplayName = "CSFO",IsGroupBy = false },

            new PositionAndCommodity { Id=66,ParentId=0,CompanyName = "SG-ANA",Position = "SG ANA",Name = "CRBO",ProductGroup="RICE BRAN OIL",Order = 46,DisplayName = "CRBO",IsGroupBy = false },

            new PositionAndCommodity { Id=67,ParentId=0,CompanyName = "SG-ANA",Position = "SG ANA",Name = "CDSBO",ProductGroup="SOYABEAN OIL",Order = 47,DisplayName = "CDSBO",IsGroupBy = false },

            new PositionAndCommodity { Id=68,ParentId=0,CompanyName = "SG-ANA",Position = "SG ANA",Name = "CRUDE GLYCERIN",ProductGroup="GLYCERIN",Order = 48,DisplayName = "Crude Glycerin",IsGroupBy = false },

            new PositionAndCommodity { Id=69,ParentId=0,CompanyName = "SG-ANA",Position = "SG ANA",Name = "RBD PALM OLEIN-TRADING",Order = 49,DisplayName = "RBD Palm Olein (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=70,ParentId=0,CompanyName = "SG-ANA",Position = "SG ANA",Name = "REFINED PALM OIL-TRADING",Order = 50,DisplayName = "Refined Palm Oil (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=71,ParentId=0,CompanyName = "SG-ANA",Position = "SG ANA",Name = "RSFO-TRADING",Order = 51,DisplayName = "RSFO (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=72,ParentId=0,CompanyName = "SG-ANA",Position = "SG ANA",Name = "RRBO-TRADING",Order = 52,DisplayName = "RRBO (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=73,ParentId=0,CompanyName = "SG-ANA",Position = "SG ANA",Name = "RSBO-TRADING",Order = 53,DisplayName = "RSBO (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=74,ParentId=0,CompanyName = "SG-ANA",Position = "SG ANA",Name = "REFINED GLYCERIN-TRADING",Order = 54,DisplayName = "Refined Glycerin (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=75,ParentId=0,CompanyName = "SG-ANA",Position = "SG ANA",Name = "SG ANA-TOTAL",Order = 55,DisplayName = "SG ANA-Total",IsGroupBy = false },
            
            //---------//


            new PositionAndCommodity { Id=76,ParentId=0,CompanyName = "ORIMU-SG",Position = "ORIMU SG",Order = 56,DisplayName = "ORIMU SG",IsGroupBy = true },

            new PositionAndCommodity { Id=77,ParentId=0,CompanyName = "ORIMU-SG",Position = "ORIMU SG",Name = "CPO",ProductGroup="PALM OIL",Order = 57,DisplayName = "CPO",IsGroupBy = false },

            new PositionAndCommodity { Id=78,ParentId=0,CompanyName = "ORIMU-SG",Position = "ORIMU SG",Name = "CSFO",ProductGroup="SUNFLOWER OIL",Order = 58,DisplayName = "CSFO",IsGroupBy = false },

            new PositionAndCommodity { Id=79,ParentId=0,CompanyName = "ORIMU-SG",Position = "ORIMU SG",Name = "CRBO",ProductGroup="RICE BRAN OIL",Order = 59,DisplayName = "CRBO",IsGroupBy = false },

            new PositionAndCommodity { Id=80,ParentId=0,CompanyName = "ORIMU-SG",Position = "ORIMU SG",Name = "CDSBO",ProductGroup="SOYABEAN OIL",Order = 60,DisplayName = "CDSBO",IsGroupBy = false },

            new PositionAndCommodity { Id=81,ParentId=0,CompanyName = "ORIMU-SG",Position = "ORIMU SG",Name = "CRUDE GLYCERIN",ProductGroup="GLYCERIN",Order = 61,DisplayName = "Crude Glycerin",IsGroupBy = false },

            new PositionAndCommodity { Id=82,ParentId=0,CompanyName = "ORIMU-SG",Position = "ORIMU SG",Name = "RBD PALM OLEIN-TRADING",Order = 62,DisplayName = "RBD Palm Olein (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=83,ParentId=0,CompanyName = "ORIMU-SG",Position = "ORIMU SG",Name = "REFINED PALM OIL-TRADING",Order = 63,DisplayName = "Refined Palm Oil (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=84,ParentId=0,CompanyName = "ORIMU-SG",Position = "ORIMU SG",Name = "RSFO-TRADING",Order = 64,DisplayName = "RSFO (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=85,ParentId=0,CompanyName = "ORIMU-SG",Position = "ORIMU SG",Name = "RRBO-TRADING",Order = 65,DisplayName = "RRBO (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=86,ParentId=0,CompanyName = "ORIMU-SG",Position = "ORIMU SG",Name = "RSBO-TRADING",Order = 66,DisplayName = "RSBO (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=87,ParentId=0,CompanyName = "ORIMU-SG",Position = "ORIMU SG",Name = "REFINED GLYCERIN-TRADING",Order = 67,DisplayName = "Refined Glycerin (Trading)",IsGroupBy = false },

            new PositionAndCommodity { Id=88,ParentId=0,CompanyName = "ORIMU-SG",Position = "ORIMU SG",Name = "ORIMU ANA-TOTAL",Order = 68,DisplayName = "ORIMU ANA-Total",IsGroupBy = false },
            
            new PositionAndCommodity { Id=89,ParentId=0,CompanyName = "ALL",Position = "GRAND TOTAL",Name = "GRAND-TOTAL",Order = 69,DisplayName = "GRAND TOTAL",IsGroupBy = false },

            /*
               -------P&L calculation siplification------------------

                (a + (b * c) * ( X /k)) + ((X/z) * d) + ( e + (f * n) * (X/z))

                a ==> ANA-CHENNAI-CUSTOMS DUTY>>"totalPaidDutyInclIgstValueInr"
                b ==> ANA-CHENNAI-CUSTOMS DUTY>>"totalUnpaidDutyQuantityMt"
                c ==> ANA+Umiro>> Duty>>"inrCustomsDutyPerMt"
                d ==> ANA-CHENNAI-PURCHASE-NEW>>>"valueInr"
                e ==> FX PAYMENTS-ANA-INDIA>>"totalFxSettledValueInInr" 
                f ==> FX PAYMENTS-ANA-INDIA>>fxValuePendingRemittance
                n ==> ANA+Umiro>>DAILY RATES>>"usdToInr"
                k ==> ANA-CHENNAI-PURCHASE-NEW>>>SOT Quantity
                X ==> TOTAL of ANA-CHENNAI-SALES>>"quantityMt2"
                z ==> ANA-CHENNAI-PURCHASE-NEW>>> "contractQuantityMt"

                 ===> a + e + X * (b * c / k + d / z + f * n / z)
            
                totalPaidDutyInclIgstValueInr + totalFxSettledValueInInr
                + (totalUnpaidDutyQuantityMt * inrCustomsDutyPerMt * (1 / SOT Quantity))
                + (valueInr * (1 / contractQuantityMt))
                + (fxValuePendingRemittance * usdToInr * (1 / contractQuantityMt))
                + (X * (1))

             */
        };
    }
}
