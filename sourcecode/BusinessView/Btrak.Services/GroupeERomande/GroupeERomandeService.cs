using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.BankAccount;
using Btrak.Models.CompanyStructure;
using Btrak.Models.EntryForm;
using Btrak.Models.File;
using Btrak.Models.GRD;
using Btrak.Models.GrERomande;
using Btrak.Models.MasterData;
using Btrak.Models.MessageFieldType;
using Btrak.Models.Site;
using Btrak.Models.SystemManagement;
using Btrak.Models.TVA;
using Btrak.Services.Audit;
using Btrak.Services.Chromium;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.File;
using Btrak.Services.Helpers.GroupeERomande;
using BTrak.Common;
using Microsoft.Azure;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using static BTrak.Common.Enumerators;

namespace Btrak.Services.GroupeERomande
{
    public class GroupeERomandeService : IGroupeERomandeService
    {
        private readonly GroupeERomandeRepository _groupeRepository;
        private readonly IAuditService _auditService;
        private readonly GoalRepository _goalRepository;
        private readonly IEmailService _emailService;
        private readonly IChromiumService _chromiumService;
        private readonly GRDRepository _gRDRepository;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly SiteRepository _siteRepository;
        private readonly UserRepository _userRepository;
        private readonly FileRepository _fileRepository;
        private readonly BankAccountRepository _bankAccountRepository;
        public GroupeERomandeService(IAuditService auditService, GroupeERomandeRepository groupeRepository,
              GoalRepository goalRepository, IEmailService emailService, IChromiumService chromiumService,
              ICompanyStructureService companyStructureService, MasterDataManagementRepository masterDataManagementRepository,
              SiteRepository siteRepository, GRDRepository gRDRepository, UserRepository userRepository, FileRepository fileRepository, BankAccountRepository bankAccountRepository
            )
        {
            _auditService = auditService;
            _groupeRepository = groupeRepository;
            _goalRepository = goalRepository;
            _emailService = emailService;
            _chromiumService = chromiumService;
            _companyStructureService = companyStructureService;
            _masterDataManagementRepository = masterDataManagementRepository;
            _siteRepository = siteRepository;
            _gRDRepository = gRDRepository;
            _userRepository = userRepository;
            _fileRepository = fileRepository;
            _bankAccountRepository = bankAccountRepository;
        }

        public async Task<Guid?> UpsertGroupe(GrERomandeInputModel grERomandeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGroupe", "grERomandeInput", grERomandeInput, "GroupeERomande Service"));

            if (!GroupeERomandeValidationHelper.UpsertGroupeERomandeValidation(grERomandeInput, loggedInContext, validationMessages))
            {
                return null;
            }

            grERomandeInput.StartDate = grERomandeInput.StartDate.Date;
            grERomandeInput.EndDate = grERomandeInput.EndDate.Date;
            grERomandeInput.Month = grERomandeInput.Month.Date;
            grERomandeInput.Year = grERomandeInput.Year.Date;
            grERomandeInput.GridInvoiceDate = grERomandeInput.GridInvoiceDate.Date;
            grERomandeInput.AutoConsumption = grERomandeInput.Production - grERomandeInput.Reprise;
            grERomandeInput.Id = _groupeRepository.UpsertGroupe(grERomandeInput, loggedInContext, validationMessages);

            LoggingManager.Debug(grERomandeInput.Id?.ToString());

            if (grERomandeInput.GenerateInvoice == true && validationMessages.Count == 0)
            {
                await DownloadOrSendRomandDInvoice(grERomandeInput, loggedInContext, validationMessages);
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertGroupeCommandId, grERomandeInput, loggedInContext);

            return grERomandeInput.Id;
        }

        public List<GrERomandeSearchOutputModel> GetGroupe(GrERomandeSearchInputModel grERomandeSearchInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetGroupe", "grERomandeSearchInput", grERomandeSearchInput, "GroupeERomande Service"));

            _auditService.SaveAudit(AppCommandConstants.GetGroupeCommandId, grERomandeSearchInput, loggedInContext);

            return _groupeRepository.GetGroupe(grERomandeSearchInput, loggedInContext, validationMessages);
        }

        public async Task<string> DownloadOrSendRomandDInvoice(GrERomandeInputModel invoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadOrSendPdfInvoice", "Invoice Service"));
            {
                var siteoutputModel = new SiteOutpuModel();
                var grdoutputModel = new GRDSearchOutputModel();
                var bankoutputModel = new BankAccountSearchOutputModel();

                string address = string.Empty;
                if (invoiceInputModel.SiteId != null)
                {
                    var siteSearchModel = new SiteOutpuModel();
                    siteSearchModel.Id = invoiceInputModel.SiteId;
                    siteoutputModel = _siteRepository.GetSite(siteSearchModel, loggedInContext, validationMessages).FirstOrDefault();
                    if (siteoutputModel != null)
                    {
                        if (siteoutputModel.Address != null)
                        {
                            address = siteoutputModel.Address.Replace("\n", "<br/>");
                            //         invoicePdfView += "<div class=\"fxFlex100\"></div></div>" +
                            //"<div class=\"fxFlex50-column-end\"><div class=\"fxFlex100-end mt-02\"><span  class=\"page-font\" style=\"text-align: right;\">" + address + "</span></div>";
                        }
                    }
                }

                if (invoiceInputModel.GrdId != null)
                {
                    var grdSearchInputModel = new GRDSearchInputModel();
                    grdSearchInputModel.Id = invoiceInputModel.GrdId;
                    grdoutputModel = _gRDRepository.GetGRD(grdSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();
                }
                if (invoiceInputModel.BankId != null)
                {
                    var bankSearchInputModel = new BankAccountSearchInputModel();
                    bankSearchInputModel.Id = invoiceInputModel.BankId;
                    bankSearchInputModel.IsArchived = false;
                    bankoutputModel = _bankAccountRepository.GetBankAccount(bankSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();
                }

                string html = string.Empty;

                string substringValue = null;
                CultureInfo ci = new CultureInfo("fr-FR");
                string monthName = invoiceInputModel.Month.ToString("MMMM", ci);
                if (monthName.Length <= 4)
                {
                    substringValue = monthName;
                }
                else
                {
                    substringValue = monthName.Substring(0, 4);
                }

                if(substringValue == "févr")
                {
                    substringValue = "fevr";
                }
                else if(substringValue == "août")
                {
                    substringValue = "aout";
                } else if(substringValue == "déce")
                {
                    substringValue = "dece";
                }

                var invoceDetails = _groupeRepository.GetGroupe(new GrERomandeSearchInputModel() { Id = invoiceInputModel.Id }, loggedInContext, validationMessages).FirstOrDefault();
                string siteName = "";
                string siteDFName = "";

                invoiceInputModel.IsGre = invoceDetails.IsGre;

                var fileName = siteoutputModel.Name + "-" + invoiceInputModel.Month.ToString("yyyy");

                if (invoiceInputModel.IsGre == true)
                {
                    fileName += "-" + substringValue;
                }
                else
                {
                    fileName += "-" + invoiceInputModel.Term;
                }

                if (invoiceInputModel.IsGre == true)
                {
                    siteName = "GRE_" + siteoutputModel.Name + "_" + invoiceInputModel.Month.ToString("yyyy") + "." + substringValue + "(PRA)";
                    siteDFName = "GRE_" + siteoutputModel.Name + "_" + invoiceInputModel.Month.ToString("yyyy") + "." + substringValue + "(DF)";
                }
                else
                {
                    siteName = "RE_" + siteoutputModel.Name + "_" + invoiceInputModel.Month.ToString("yyyy") + "." + invoiceInputModel.Term + "(PRA)";
                    siteDFName = "RE_" + siteoutputModel.Name + "_" + invoiceInputModel.Month.ToString("yyyy") + "." + invoiceInputModel.Term + "(DF)";
                }
                string facturationValue = invoiceInputModel.Facturation.ToString();
                List<EntryFormFieldReturnOutputModel> pRAFields = new List<EntryFormFieldReturnOutputModel>();
                List<EntryFormFieldReturnOutputModel> dFFields = new List<EntryFormFieldReturnOutputModel>();
                if (invoiceInputModel.PRAFields != null)
                {
                    pRAFields = JsonConvert.DeserializeObject<List<EntryFormFieldReturnOutputModel>>(invoiceInputModel.PRAFields);

                }
                if (invoiceInputModel.DFFields != null)
                {
                    dFFields = JsonConvert.DeserializeObject<List<EntryFormFieldReturnOutputModel>>(invoiceInputModel.DFFields);
                }
                if (pRAFields.Count > 0)
                {
                    pRAFields = pRAFields.Where(x => x.EnteredResult > Convert.ToDecimal(0.0)).ToList();
                }
                if (dFFields.Count > 0)
                {
                    dFFields = dFFields.Where(x => x.EnteredResult > Convert.ToDecimal(0.0)).ToList();
                }
                string pRAFieldString = "";
                foreach (var prafield in pRAFields)
                {
                    pRAFieldString += "<tr>";
                    pRAFieldString += "<td class=\"b\" style=\"width: 2.8cm\">" + siteName + " </td>";
                    pRAFieldString += "<td class=\"b\" style=\"width: 50px\"><center>" + invoiceInputModel.StartDate.ToString("dd/MM/yyyy") + "</center></td>";
                    pRAFieldString += "<td class=\"b\" style=\"width: 50px\"><center>" + invoiceInputModel.EndDate.ToString("dd/MM/yyyy") + "</center></td>";
                    pRAFieldString += "<td class=\"b\"><center>" + prafield.DisplayName + "(" + prafield.Unit + ")" + "</center></td>";
                    pRAFieldString += "<td class=\"b\"><center></center></td>";
                    pRAFieldString += "<td class=\"b\"><center></center></td>";
                    pRAFieldString += "<td class=\"b\"><center></center></td>";
                    pRAFieldString += "<td class=\"b\"><center></center></td>";
                    if(prafield.Unit == "kWh")
                    {
                        if (prafield.EnteredResult.ToString().Length <= 1)
                        {
                            pRAFieldString += "<td class=\"f align-right\">" + prafield.EnteredResult + "</td>";
                        }
                        else
                        {
                            pRAFieldString += "<td class=\"f align-right\" >" + string.Format(CultureInfo.InvariantCulture, "{0:0,0}", prafield.EnteredResult) + "</td>";
                        }
                    } else
                    {
                        if (prafield.EnteredResult.ToString().Split('.')[0].Length <= 1)
                        {
                            //pRAFieldString += "<td class=\"b\"><center>" + Convert.ToDecimal(prafield.EnteredResult).ToString("0.00") + "</center></td>";
                            pRAFieldString += "<td class=\"f align-right\">" + Convert.ToDecimal(prafield.EnteredResult).ToString("0.00") + "</td>";
                        }
                        else
                        {
                            //pRAFieldString += "<td class=\"b\"><center>" + string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", prafield.EnteredResult) + "</center></td>";
                            pRAFieldString += "<td class=\"f align-right\">" + string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", prafield.EnteredResult) + "</td>";
                        }
                    }
                   
                    pRAFieldString += "</tr>";
                }
                string dFFieldString = "";
                foreach (var prafield in dFFields)
                {
                    dFFieldString += "<tr>";
                    dFFieldString += "<td class=\"b\" style=\"width: 2.8cm\">" + siteDFName + "</td>";
                    dFFieldString += "<td class=\"b\" style=\"width: 50px\"><center>" + invoiceInputModel.StartDate.ToString("dd/MM/yyyy") + "</center></td>";
                    dFFieldString += "<td class=\"b\" style=\"width: 50px\"><center>" + invoiceInputModel.EndDate.ToString("dd/MM/yyyy") + "</center></td>";
                    dFFieldString += "<td class=\"b\"><center>" + prafield.DisplayName + "(" + prafield.Unit + ")" + "</center></td>";
                    dFFieldString += "<td class=\"b\"><center></center></td>";
                    if(prafield.Unit == "kWh")
                    {
                        if (prafield.EnteredResult.ToString().Length <= 1)
                        {
                            dFFieldString += "<td class=\"b\"><center>" + prafield.EnteredResult + "</center></td>";
                        }
                        else
                        {
                            dFFieldString += "<td class=\"b\"><center>" + string.Format(CultureInfo.InvariantCulture, "{0:0,0}", prafield.EnteredResult) + "</center></td>";
                        }
                    } else
                    {
                        dFFieldString += "<td class=\"b\"><center></center></td>";
                    }
                   
                    dFFieldString += "<td class=\"b\"><center></center></td>";
                    dFFieldString += "<td class=\"b\"><center></center></td>";
                    if (prafield.Unit == "CHF")
                    {
                        if (prafield.EnteredResult.ToString().Split('.')[0].Length <= 1)
                        {
                            //pRAFieldString += "<td class=\"b\"><center>" + Convert.ToDecimal(prafield.EnteredResult).ToString("0.00") + "</center></td>";
                            dFFieldString += "<td class=\"f align-right\">" + Convert.ToDecimal(prafield.EnteredResult).ToString("0.00") + "</td>";
                        }
                        else
                        {
                            //pRAFieldString += "<td class=\"b\"><center>" + string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", prafield.EnteredResult) + "</center></td>";
                            dFFieldString += "<td class=\"f align-right\">" + string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", prafield.EnteredResult) + "</td>";
                        }
                    } else
                    {
                        dFFieldString += "<td class=\"b\"><center></center></td>";
                    }
                        

                    dFFieldString += "</tr>";
                }
                string HautTariffString = "";
                if (invoiceInputModel.HauteTariff != 0)
                {
                    HautTariffString += "<tr>";
                    HautTariffString += "<td class=\"b\" style=\"width: 2.8cm\">" + siteDFName + "</td>";
                    HautTariffString += "<td class=\"b\" style=\"width: 50px\"><center>" + invoiceInputModel.StartDate.ToString("dd/MM/yyyy") + "</center></td>";
                    HautTariffString += "<td class=\"b\" style=\"width: 50px\"><center>" + invoiceInputModel.EndDate.ToString("dd/MM/yyyy") + "</center></td>";
                    if(invoiceInputModel.BasTariff != 0)
                    {
                        HautTariffString += "<td class=\"b\"><center>Haut Tarif</center></td>";
                    }
                    else
                    {
                        HautTariffString += "<td class=\"b\"><center>Tarif Unitaire</center></td>";
                    }
                    HautTariffString += "<td class=\"b\"><center>(kWh)</center></td>";
                    if (invoiceInputModel.HauteTariff.ToString().Length <= 1)
                    {
                        HautTariffString += "<td class=\"b\"><center>" + invoiceInputModel.HauteTariff + "</center></td>";
                    }
                    else
                    {
                        HautTariffString += "<td class=\"b\"><center>" + string.Format(CultureInfo.InvariantCulture, "{0:0,0}", invoiceInputModel.HauteTariff) + "</center></td>";
                    }
                    HautTariffString += "<td class=\"b\"><center></center></td>";
                    HautTariffString += "<td class=\"b\"><center></center></td>";
                    HautTariffString += "<td class=\"b\"><center></center></td>";

                    HautTariffString += "</tr>";
                }
                string BasTariffString = "";
                if (invoiceInputModel.BasTariff != 0)
                {
                    BasTariffString += "<tr>";
                    BasTariffString += "<td class=\"b\" style=\"width: 2.8cm\">" + siteDFName + "</td>";
                    BasTariffString += "<td class=\"b\" style=\"width: 50px\"><center>" + invoiceInputModel.StartDate.ToString("dd/MM/yyyy") + "</center></td>";
                    BasTariffString += "<td class=\"b\" style=\"width: 50px\"><center>" + invoiceInputModel.EndDate.ToString("dd/MM/yyyy") + "</center></td>";
                    BasTariffString += "<td class=\"b\"><center>Bas Tarif</center></td>";
                    BasTariffString += "<td class=\"b\"><center>(kWh)</center></td>";
                    if (invoiceInputModel.BasTariff.ToString().Length <= 1)
                    {
                        BasTariffString += "<td class=\"b\"><center>" + invoiceInputModel.HauteTariff + "</center></td>";
                    }
                    else
                    {
                        BasTariffString += "<td class=\"b\"><center>" + string.Format(CultureInfo.InvariantCulture, "{0:0,0}", invoiceInputModel.BasTariff) + "</center></td>";
                    }
                    BasTariffString += "<td class=\"b\"><center></center></td>";
                    BasTariffString += "<td class=\"b\"><center></center></td>";
                    BasTariffString += "<td class=\"b\"><center></center></td>";

                    BasTariffString += "</tr>";
                }
                string TotalTarrif = "";
                if (invoiceInputModel.TariffTotal != 0 || invoiceInputModel.TariffTotal != 0)
                {
                    TotalTarrif += "<tr>";
                    TotalTarrif += "<td class=\"b\" style=\"width: 2.8cm\">" + siteDFName + "</td>";
                    TotalTarrif += "<td class=\"b\" style=\"width: 50px\"><center>" + invoiceInputModel.StartDate.ToString("dd/MM/yyyy") + "</center></td>";
                    TotalTarrif += "<td class=\"b\" style=\"width: 50px\"><center>" + invoiceInputModel.EndDate.ToString("dd/MM/yyyy") + "</center></td>";
                    TotalTarrif += "<td class=\"b\"><center>Total</center></td>";
                    TotalTarrif += "<td class=\"b\"><center>(kWh)</center></td>";
                    if (invoiceInputModel.TariffTotal.ToString().Length <= 1)
                    {
                        TotalTarrif += "<td class=\"b\"><center>" + invoiceInputModel.TariffTotal + "</center></td>";
                    }
                    else
                    {
                        TotalTarrif += "<td class=\"b\"><center>" + string.Format(CultureInfo.InvariantCulture, "{0:0,0}", invoiceInputModel.TariffTotal) + "</center></td>";
                    }
                    TotalTarrif += "<td class=\"b\"><center></center></td>";
                    TotalTarrif += "<td class=\"b\"><center></center></td>";
                    TotalTarrif += "<td class=\"b\"><center></center></td>";

                    TotalTarrif += "</tr>";
                }


                if (invoiceInputModel.IsGre == true)
                {

                    html = _goalRepository.GetHtmlTemplateByName("InvoicePDFGroupeETemplate", loggedInContext.CompanyGuid);

                    invoiceInputModel.AutoConsumption = Convert.ToInt64(invoiceInputModel.Production - invoiceInputModel.Reprise);
                    decimal consumPer = invoiceInputModel.AutoConsumption / invoiceInputModel.Production;
                    string percentageConsumerper = string.Empty;

                    if (consumPer.ToString().Split('.')[0].Length <= 1)
                    {
                        percentageConsumerper = Math.Round((consumPer * 100), 2).ToString("0.00");
                    }
                    else
                    {
                        percentageConsumerper = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", Math.Round(consumPer * 100), 2);
                    }


                    string autoConsumptionSum = string.Empty;
                    if (invoiceInputModel.AutoConsumptionSum.ToString().Split('.')[0].Length <= 1)
                    {
                        autoConsumptionSum = invoiceInputModel.AutoConsumptionSum.ToString("0.00");
                    }
                    else
                    {
                        autoConsumptionSum = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.AutoConsumptionSum);
                    }

                    string facturation = string.Empty;

                    if (facturationValue.Split('.')[0].Length <= 1)
                    {
                        facturation = invoiceInputModel.Facturation.ToString("0.00");
                    }
                    else
                    {
                        facturation = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.Facturation);
                    }

                    string facturationSum = string.Empty;
                    if (invoiceInputModel.PRATotal.ToString().Split('.')[0].Length <= 1)
                    {
                        facturationSum = Convert.ToDecimal(invoiceInputModel.PRATotal).ToString("0.00");
                    }
                    else
                    {
                        facturationSum = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.PRATotal);
                    }

                    string distribution = string.Empty;
                    if (invoiceInputModel.Distribution.ToString().Split('.')[0].Length <= 1)
                    {
                        distribution = Convert.ToDecimal(invoiceInputModel.Distribution).ToString("0.00");
                    }
                    else
                    {
                        distribution = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.Distribution);
                    }

                    string greFacturation = string.Empty;
                    if (invoiceInputModel.GreFacturation.ToString().Split('.')[0].Length <= 1)
                    {
                        greFacturation = Convert.ToDecimal(invoiceInputModel.GreFacturation).ToString("0.00");
                    }
                    else
                    {
                        greFacturation = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.GreFacturation);
                    }

                    string greTotal = string.Empty;
                    if (invoiceInputModel.GreTotal.ToString().Split('.')[0].Length <= 1)
                    {
                        greTotal = Convert.ToDecimal(invoiceInputModel.GreTotal).ToString("0.00");
                    }
                    else
                    {
                        greTotal = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.GreTotal);
                    }

                    string subTotal = string.Empty;
                    if (invoiceInputModel.SubTotal.ToString().Split('.')[0].Length <= 1)
                    {
                        subTotal = Convert.ToDecimal(invoiceInputModel.SubTotal).ToString("0.00");
                    }
                    else
                    {
                        subTotal = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.SubTotal);
                    }

                    string tVA = string.Empty;
                    if (invoiceInputModel.TVA.ToString().Split('.')[0].Length <= 1)
                    {
                        tVA = invoiceInputModel.TVA.ToString("0.00");
                    }
                    else
                    {
                        tVA = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.TVA);
                    }

                    string tVAForSubTotal = string.Empty;
                    if (invoiceInputModel.TVAForSubTotal.ToString().Split('.')[0].Length <= 1)
                    {
                        tVAForSubTotal = Convert.ToDecimal(invoiceInputModel.TVAForSubTotal).ToString("0.00");
                    }
                    else
                    {
                        tVAForSubTotal = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.TVAForSubTotal);
                    }

                    string total = string.Empty;
                    if (invoiceInputModel.Total.ToString().Split('.')[0].Length <= 1)
                    {
                        total = Convert.ToDecimal(invoiceInputModel.Total).ToString("0.00");
                    }
                    else
                    {
                        total = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.Total);
                    }

                    decimal totalValue = Math.Round((invoiceInputModel.Total), 2);

                    decimal totalValueResult = 0;


                    decimal mRound = totalValue / Convert.ToDecimal(0.05);
                    int result = (int)((mRound - (int)mRound) * 10);

                    if (result < 5)
                    {
                        mRound = Math.Floor(mRound);
                        totalValueResult = mRound * Convert.ToDecimal(0.05);
                    }
                    if (result >= 5)
                    {
                        mRound = Math.Ceiling(mRound);
                        totalValueResult = mRound * Convert.ToDecimal(0.05);
                    }

                    decimal aroundiDifference = Math.Round(totalValueResult - invoiceInputModel.Total, 2);

                    bool positiveNumber = aroundiDifference > 0;
                    decimal exactaroundi = 0;

                    if (positiveNumber == false)
                    {
                        exactaroundi = (Math.Abs(-aroundiDifference));
                    }
                    else
                    {
                        exactaroundi = aroundiDifference;
                    }

                    string arrondi = string.Empty;
                    if (exactaroundi.ToString().Split('.')[0].Length <= 1)
                    {
                        arrondi = Convert.ToDecimal(aroundiDifference).ToString("0.00");
                    }
                    else
                    {
                        arrondi = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", aroundiDifference);
                    }

                    string totalValueOutput = string.Empty;
                    if (totalValueResult.ToString().Split('.')[0].Length <= 1)
                    {
                        totalValueOutput = Convert.ToDecimal(totalValueResult).ToString("0.00");
                    }
                    else
                    {
                        totalValueOutput = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", totalValueResult);
                    }

                    html = html.Replace("##Address##", address).Replace("##GridInvoiceDate##", invoiceInputModel.GridInvoiceDate.ToString("dd/MM/yyyy")).Replace("##FileName##", fileName).Replace("##SiteName##", siteoutputModel.Name)

                        .Replace("##Month##", invoiceInputModel.Month.ToString("MMM-yyyy")).Replace("##StartDate##", invoiceInputModel.StartDate.ToString("dd/MM/yyyy")).Replace("##EndDate##", invoiceInputModel.EndDate.ToString("dd/MM/yyyy"))
                        .Replace("##Production##", string.Format(CultureInfo.InvariantCulture, "{0:0,0}", invoiceInputModel.Production)).Replace("##Reprise##", string.Format(CultureInfo.InvariantCulture, "{0:0,0}", invoiceInputModel.Reprise))
                        .Replace("##Autoconsommation##", string.Format(CultureInfo.InvariantCulture, "{0:0,0}", invoiceInputModel.Production - invoiceInputModel.Reprise))
                        .Replace("##Percentage##", percentageConsumerper).Replace("##praName##", siteName)
                        .Replace("##AutoCTariff##", string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.AutoCTariff)).Replace("##AutoConsumptionSum##", autoConsumptionSum).Replace("##grdName##", grdoutputModel.Name)
                        .Replace("##Facturation##", facturation).Replace("##FacturationSum##", facturationSum).Replace("##Distribution##", distribution).Replace("##GreFacturation##", greFacturation).Replace("##GreTotal##", greTotal)
                        .Replace("##SubTotal##", subTotal).Replace("##TVA##", tVA).Replace("##TVAForSubTotal##", tVAForSubTotal).Replace("##Total##", total).Replace("##Arrondi##", arrondi).Replace("##TotalValue##", totalValueOutput)
                        .Replace("##Beneficiaire##", bankoutputModel.Beneficiaire).Replace("##Iban##", bankoutputModel.Iban).Replace("##Banque##", bankoutputModel.Banque).Replace("##HautTariff##", HautTariffString).Replace("##BasTariff##", BasTariffString).Replace("##TotalTariff##", TotalTarrif);
                    html = html.Replace("##Prastring##", pRAFieldString);
                    html = html.Replace("##DFstring##", dFFieldString);
                }
                else
                {
                    html = _goalRepository.GetHtmlTemplateByName("InvoicePDFRomandeETemplate", loggedInContext.CompanyGuid); invoiceInputModel.AutoConsumption = Convert.ToInt64(invoiceInputModel.Production - invoiceInputModel.Reprise);
                    decimal consumPer = invoiceInputModel.AutoConsumption / invoiceInputModel.Production;
                    string percentageConsumerper = string.Empty; if (consumPer.ToString().Split('.')[0].Length <= 1)
                    {
                        percentageConsumerper = Math.Round((consumPer * 100), 2).ToString("0.00");
                    }
                    else
                    {
                        percentageConsumerper = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", Math.Round(consumPer * 100), 2);
                    }
                    string distribution = string.Empty;
                    if (invoiceInputModel.Distribution.ToString().Split('.')[0].Length <= 1)
                    {
                        distribution = Convert.ToDecimal(invoiceInputModel.Distribution).ToString("0.00");
                    }
                    else
                    {
                        distribution = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.Distribution);
                    }
                    string autoConsumptionSum = string.Empty;
                    if (invoiceInputModel.AutoConsumptionSum.ToString().Split('.')[0].Length <= 1)
                    {
                        autoConsumptionSum = invoiceInputModel.AutoConsumptionSum.ToString("0.00");
                    }
                    else
                    {
                        autoConsumptionSum = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.AutoConsumptionSum);
                    }
                    string facturation = string.Empty;
                    if (facturationValue.Split('.')[0].Length <= 1)
                    {
                        facturation = invoiceInputModel.Facturation.ToString("0.00");
                    }
                    else
                    {
                        facturation = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.Facturation);
                    }
                    string facturationSum = string.Empty;
                    if (invoiceInputModel.PRATotal.ToString().Split('.')[0].Length <= 1)
                    {
                        facturationSum = Convert.ToDecimal(invoiceInputModel.PRATotal).ToString("0.00");
                    }
                    else
                    {
                        facturationSum = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.PRATotal);
                    }
                    string administrationRomandeE = string.Empty;
                    if (invoiceInputModel.AdministrationRomandeE.ToString().Split('.')[0].Length <= 1)
                    {
                        administrationRomandeE = Convert.ToDecimal(invoiceInputModel.AdministrationRomandeE).ToString("0.00");
                    }
                    else
                    {
                        administrationRomandeE = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.AdministrationRomandeE);
                    }
                    string administrationRomandeESum = string.Empty;
                    decimal? SumAdministrationRomandeE = invoiceInputModel.AdministrationRomandeE + invoiceInputModel.Facturation;
                    if (SumAdministrationRomandeE.ToString().Split('.')[0].Length <= 1)
                    {
                        administrationRomandeESum = Convert.ToDecimal(SumAdministrationRomandeE).ToString("0.00");
                    }
                    else
                    {
                        administrationRomandeESum = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", SumAdministrationRomandeE);
                    }
                    decimal sum = Convert.ToDecimal(facturationSum) + Convert.ToDecimal(invoiceInputModel.Distribution);
                    string subTotal = string.Empty;
                    if (invoiceInputModel.SubTotal.ToString().Split('.')[0].Length <= 1)
                    {
                        subTotal = invoiceInputModel.SubTotal.ToString("0.00");
                    }
                    else
                    {
                        subTotal = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.SubTotal);
                    }
                    decimal TvAforSubTotal = Math.Round(sum, 2) * invoiceInputModel.TVA; string tVA = string.Empty;
                    if (invoiceInputModel.TVA.ToString().Split('.')[0].Length <= 1)
                    {
                        tVA = invoiceInputModel.TVA.ToString("0.00");
                    }
                    else
                    {
                        tVA = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.TVA);
                    }
                    string tVAForSubTotal = string.Empty;
                    if (invoiceInputModel.TVAForSubTotal.ToString().Split('.')[0].Length <= 1)
                    {
                        tVAForSubTotal = Convert.ToDecimal(invoiceInputModel.TVAForSubTotal).ToString("0.00");
                    }
                    else
                    {
                        tVAForSubTotal = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.TVAForSubTotal);
                    }
                    decimal tvaValue = Math.Round(Math.Round(TvAforSubTotal / 100, 2) + invoiceInputModel.SubTotal, 2);
                    string tvaValueResult = string.Empty;
                    if (tvaValue.ToString().Split('.')[0].Length <= 1)
                    {
                        tvaValueResult = tvaValue.ToString("0.00");
                    }
                    else
                    {
                        tvaValueResult = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", tvaValue);
                    }
                    decimal totalValue = Math.Round(Math.Round(TvAforSubTotal / 100, 2) + invoiceInputModel.SubTotal, 2); decimal totalValueResult = 0; decimal mRound = totalValue / Convert.ToDecimal(0.05);
                    int result = (int)((mRound - (int)mRound) * 10);
                    if (result < 5)
                    {
                        mRound = Math.Floor(mRound);
                        totalValueResult = mRound * Convert.ToDecimal(0.05);
                    }
                    if (result >= 5)
                    {
                        mRound = Math.Ceiling(mRound);
                        totalValueResult = mRound * Convert.ToDecimal(0.05);
                    }
                    decimal aroundiDifference = Math.Round(totalValueResult - invoiceInputModel.Total, 2); bool positiveNumber = aroundiDifference > 0;
                    decimal exactaroundi = 0; string arrondi = string.Empty; if (positiveNumber == false)
                    {
                        exactaroundi = (Math.Abs(-aroundiDifference));
                    }
                    else
                    {
                        exactaroundi = aroundiDifference;
                    }
                    if (exactaroundi.ToString().Split('.')[0].Length <= 1)
                    {
                        arrondi = Convert.ToDecimal(aroundiDifference).ToString("0.00");
                    }
                    else
                    {
                        arrondi = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", aroundiDifference);
                    }
                    string totalValueDisplay = string.Empty;
                    if (totalValueResult.ToString().Split('.')[0].Length <= 1)
                    {
                        totalValueDisplay = Convert.ToDecimal(totalValueResult).ToString("0.00");
                    }
                    else
                    {
                        totalValueDisplay = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", totalValueResult);
                    } 

                    html = html.Replace("##Address##", address).Replace("##GridInvoiceDate##", invoiceInputModel.GridInvoiceDate.ToString("dd/MM/yyyy")).Replace("##FileName##", fileName).Replace("##SiteName##", siteoutputModel.Name).Replace("##Prastring##", pRAFieldString).Replace("##DFstring##", dFFieldString)
                    .Replace("##GRDName##", grdoutputModel.Name).Replace("##Month##", invoiceInputModel.Month.ToString("MMM-yyyy")).Replace("##StartDate##", invoiceInputModel.StartDate.ToString("dd/MM/yyyy"))
                    .Replace("##EndDate##", invoiceInputModel.EndDate.ToString("dd/MM/yyyy")).Replace("##Production##", string.Format(CultureInfo.InvariantCulture, "{0:0,0}", invoiceInputModel.Production))
                    .Replace("##Reprise##", string.Format(CultureInfo.InvariantCulture, "{0:0,0}", invoiceInputModel.Reprise))
                    .Replace("##Autoconsommation##", string.Format(CultureInfo.InvariantCulture, "{0:0,0}", invoiceInputModel.Production - invoiceInputModel.Reprise))
                    .Replace("##Percentage##", percentageConsumerper).Replace("##AutoCTariff##", string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", invoiceInputModel.AutoCTariff))
                    .Replace("##AutoConsumptionSum##", autoConsumptionSum).Replace("##Facturation##", facturation).Replace("##FacturationSum##", facturationSum).Replace("##grdName##", grdoutputModel.Name)
                    .Replace("##AdministrationRomandeE##", administrationRomandeE).Replace("##AdministrationRomandeESum##", administrationRomandeESum).Replace("##SubTotal##", subTotal).Replace("##Distribution##", distribution)
                    .Replace("##TVA##", tVA).Replace("##TVAForSubTotal##", tVAForSubTotal).Replace("##tvaValue##", tvaValueResult)
                    .Replace("##Arrondi##", arrondi).Replace("##TotalValue##", totalValueDisplay).Replace("##Beneficiaire##", bankoutputModel.Beneficiaire).Replace("##Iban##", bankoutputModel.Iban)
                    .Replace("##Banque##", bankoutputModel.Banque).Replace("##praName##", siteName).Replace("##HautTariff##", HautTariffString.Replace("##BasTariff##", BasTariffString).Replace("##TotalTariff##", TotalTarrif));
                }

                var pdfOutput = await _chromiumService.GeneratePdf(html, null, invoiceInputModel.Id.ToString());

                CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
                companySettingsSearchInputModel.CompanyId = companyModel?.CompanyId;
                companySettingsSearchInputModel.IsSystemApp = null;
                string storageAccountName = string.Empty;

                List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
                if (companySettings.Count > 0)
                {
                    var storageAccountDetails = companySettings.Where(x => x.Key == "StorageAccountName").FirstOrDefault();
                    storageAccountName = storageAccountDetails?.Value;
                }

                var directory = SetupCompanyFileContainer(companyModel, 6, loggedInContext.LoggedInUserId, storageAccountName);

                LoggingManager.Debug("UploadCourseFile input fileName:" + fileName);

                fileName = fileName.Replace(" ", "_");

                var fileExtension = ".pdf";

                var invoceFileDetails = _groupeRepository.GetGroupe(new GrERomandeSearchInputModel() { FileUrl = fileName }, loggedInContext, validationMessages).ToList();
               
                var convertedFileName = fileName + fileExtension;

                if(invoceFileDetails.Count > 0)
                {
                    if(invoceFileDetails.Count == 1)
                    {
                        string url = invoceFileDetails[0].InvoiceUrl;
                        if(url.Contains("("))
                        {
                            int start = url.IndexOf("(") + 1;
                            int end = url.IndexOf(")", start);
                            string result = url.Substring(start, end - start);
                            int number = Convert.ToInt32(result) + 1;
                            convertedFileName = convertedFileName + "(" + number + ")";
                        }
                       else
                        {
                            convertedFileName = convertedFileName + "(" + invoceFileDetails.Count + ")";
                        }
                    } else
                    {
                        convertedFileName = convertedFileName + "(" + invoceFileDetails.Count + ")";
                    }
                }

                CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);

                blockBlob.Properties.CacheControl = "public, max-age=2592000";

                blockBlob.Properties.ContentType = "application/pdf";

                Byte[] bytes = pdfOutput.ByteStream;

                blockBlob.UploadFromByteArray(bytes, 0, bytes.Length);

                var fileurl = blockBlob.Uri.AbsoluteUri;

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadOrSendPdfInvoice", "Invoice Service"));

                LoggingManager.Debug(pdfOutput.ByteStream.ToString());

                invoiceInputModel.InvoiceUrl = fileurl;

                invoiceInputModel.TimeStamp = invoceDetails?.TimeStamp;
                
                invoiceInputModel.IsInvoiceBit = true;

                _groupeRepository.UpsertGroupe(invoiceInputModel, loggedInContext, validationMessages);

                return fileurl;
            }
        }
        public void SendRomandDInvoiceEmail(GrERomandeSearchInputModel grEInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendRomandDInvoiceEmail", "GroupeERomande Service"));

            GrERomandeSearchOutputModel grERomandeInput = _groupeRepository.GetGroupe(new GrERomandeSearchInputModel() { Id = grEInput.Id }, loggedInContext, validationMessages).FirstOrDefault();

            var messageTypes = _groupeRepository.GetMessageFieldType(new MessageFieldSearchInputModel(), loggedInContext, validationMessages);

            string html = "<html><head></head><body><div><p>Ce mail a été généré automatiquement, ne pas répondre SVP.</p><p>Pour toute communication: mfs.merchant.finance@gmail.com</p><br><p>Bonjour,</p>##ThankyouMessage##<br><p>Facture</p><p>A réception du décompte de ##GRDName## veuillez trouver en p.j. notre facture et annexes.</p><br><p>Auto-Consommation :</p><p>Total site ##GroupeE##</p><br><p>PV :</p><p>Production ##N12Month## kWh (vs ##K12## PV Syst) soit ##soitPercent##.</p><p>Autoconsommation ##Q13AutoConsumption## (##R12AutoConsumption## vs ##Budget## budget) soit ##BudegtPercent##% de la production PV.</p><br>##OutStandingAmount####GeneralMessage##<p>Nous restons à votre disposition pour tout complément d'information et vous remercions de votre collaboration.</p><br><pre style=\"font-size:15px; font-family:Roboto\">Meilleures salutations," +
"<br>Photon One SA" +
"<br>Nicolas Sanchez, Administrateur" +
"<br>+ 41 79 221 71 42 </pre></div></body></html>";

            var grdSearchInputModel = new GRDSearchInputModel();
            grdSearchInputModel.Id = grERomandeInput.GrdId;
            var grdoutputModel = _gRDRepository.GetGRD(grdSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();

            var siteSearchModel = new SiteOutpuModel();
            siteSearchModel.Id = grERomandeInput.SiteId;
            var siteoutputModel = _siteRepository.GetSite(siteSearchModel, loggedInContext, validationMessages).FirstOrDefault();

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);

            decimal? groupeEValue = grERomandeInput.IsGre == true ? (grERomandeInput.AutoConsumption + grERomandeInput.TariffTotal) : grERomandeInput.AutoConsumption;

            decimal traifTotal = Math.Round(grERomandeInput.BasTariff, 2) + Math.Round(grERomandeInput.HauteTariff, 2);

            string description1 = "##1## kWh ( ##2## GroupeE ##3## PV)";

            string description2 = "##1## kWh";

            string outStandingAmount = string.Empty;

            string thankyouMessage = string.Empty;
            string remainderMessage = string.Empty;
            string generalMessage = string.Empty;
            bool isRemainder = false;
            //string groupeDescription = grERomandeInput.IsGre == true ? (groupeEValue + "kWh" + "(" + Math.Round(grERomandeInput.AutoConsumption, 2) + "GroupeE +" + Math.Round(traifTotal, 2) + " PV)") : groupeEValue + "kWh";

            if (grERomandeInput.MessageType != null && grERomandeInput.MessageType.Length > 0)
            {
                var data = JsonConvert.DeserializeObject<List<MessageFieldTypeOutputModel>>(grERomandeInput.MessageType);

                foreach (var x in data)
                {
                    if (x.IsSendInMail == true && x.SelectedGrdIds.Contains(grERomandeInput.GrdId.ToString()))
                    {
                        if (x.MessageType == "Thank you") {
                            thankyouMessage = "<p>" + x.DisplayText + "</p>";
                        } else if (x.MessageType == "General") {
                            generalMessage = "<p>" + x.DisplayText + "</p>";
                        }
                    }
                }
            }

            foreach (var x in messageTypes)
            {
                if (x.IsDisplay == true && x.SelectedGrdIds.Contains(grERomandeInput.GrdId.ToString()))
                {
                    if (x.MessageType == "Reminder" || x.MessageType == "Remainder")
                    {
                        isRemainder = true;
                        remainderMessage = x.DisplayText;
                    }
                }
            }

            if (grERomandeInput.OutStandingAmount > 0 && isRemainder == true)
            {
                outStandingAmount = "<p>"+ remainderMessage +" " + String.Format("{0:n}", Math.Round(Convert.ToDecimal(grERomandeInput.OutStandingAmount), 2)) + "</p>";
            }


            string groupeDescription = grERomandeInput.IsGre == true ? description1.Replace("##1##", String.Format("{0:n0}", Convert.ToDecimal(groupeEValue))).Replace("##2##", String.Format("{0:n0}", traifTotal))
                .Replace("##3##", String.Format("{0:n0}", grERomandeInput.AutoConsumption)) : description2.Replace("##1##", String.Format("{0:n0}", Convert.ToDecimal(groupeEValue)));

            decimal K12Value = grERomandeInput.PlannedSystem;

            decimal soitPercent = (grERomandeInput.Production / K12Value) * 100;
            //if (grERomandeInput.SolarLogValueKwh != 0 && grERomandeInput.Production != 0)
            //{
            //    decimal proValue = grERomandeInput.Production * 100;
            //    K12Value = proValue / grERomandeInput.SolarLogValueKwh;
            //}

            decimal budgetValue = grERomandeInput.PlannedAutoC;
            //decimal budgetPercentage = (grERomandeInput.AutoConsumption / budgetValue) * 100;
            decimal budgetPercentage = (grERomandeInput.AutoConsumption / grERomandeInput.Production) * 100;
            //if (grERomandeInput.PlannedAutoC != 0 && grERomandeInput.PlannedSystem != 0)
            //{
            //    decimal PlannedAutoC = grERomandeInput.PlannedAutoC * 100;
            //    budgetValue = PlannedAutoC / grERomandeInput.PlannedSystem;
            //}

            List<FileApiReturnModel> files = _fileRepository.SearchFile(new FileSearchCriteriaInputModel() { ReferenceId = grEInput.Id, IsArchived = false }, loggedInContext, validationMessages);

            var webClient = new WebClient();
            byte[] fileBytes = webClient.DownloadData(grERomandeInput.InvoiceUrl);

            Stream stream = new MemoryStream(fileBytes);

            List<StreamWithType> fileStream = new List<StreamWithType>();

            char[] saperator = new char[2];
            saperator[0] = '/';
            saperator[1] = '.';

            var fileNameInput = grERomandeInput.InvoiceUrl.Split(saperator[0]);

            int length = fileNameInput.Count();

            var fileName = fileNameInput[length - 1].Split(saperator[1]);

            fileStream.Add(new StreamWithType() { FileStream = stream, FileType = "pdf", IsPdf = true, FileName = fileName[0] });

            html = html.Replace("##GRDName##", grdoutputModel.Name).Replace("##GroupeE##", groupeDescription).Replace("##N12Month##", String.Format("{0:n0}", grERomandeInput.Production))// + " " + grERomandeInput.Month.ToString("MMM-d", new System.Globalization.CultureInfo("fr-FR")))
                .Replace("##Q13AutoConsumption##", String.Format("{0:n0}", grERomandeInput.AutoConsumption) + "kWh").Replace("##R12AutoConsumption##", "").Replace("##K12##", String.Format("{0:n0}", K12Value) + "kWh")
                .Replace("##Budget##", String.Format("{0:n0}", budgetValue) + "kWh").Replace("##BudegtPercent##", String.Format("{0:n}", Math.Round(budgetPercentage, 2))).Replace("##soitPercent##", String.Format("{0:n}", Math.Round(soitPercent, 2)) + "%")
                .Replace("##OutStandingAmount##", outStandingAmount).Replace("##ThankyouMessage##", thankyouMessage).Replace("##RemainderMessage##", remainderMessage).Replace("##GeneralMessage##", generalMessage);
            if (files.Count > 0)
            {
                foreach (var file in files)
                {
                    var webClient1 = new WebClient();
                    byte[] fileBytes1 = webClient.DownloadData(file.FilePath);

                    Stream stream1 = new MemoryStream(fileBytes1);
                    var ispdf = false;
                    var isExcel = false;
                    var isJpg = false;
                    var isJpeg = false;
                    var isPng = false;
                    var isDocx = false;
                    var isTxt = false;

                    if (file.FileExtension.Contains(".pdf"))
                    {
                        ispdf = true;
                    }
                    else if (file.FileExtension.Contains(".xlsx"))
                    {
                        isExcel = true;
                    }
                    else if (file.FileExtension.Contains(".jpg"))
                    {
                        isJpg = true;
                    }
                    else if (file.FileExtension.Contains(".jpeg"))
                    {
                        isJpeg = true;
                    }
                    else if (file.FileExtension.Contains(".png"))
                    {
                        isPng = true;
                    }
                    else if (file.FileExtension.Contains(".docx"))
                    {
                        isDocx = true;
                    }
                    else if (file.FileExtension.Contains(".txt"))
                    {
                        isTxt = true;
                    }

                    fileStream.Add(new StreamWithType() { FileStream = stream1, FileType = file.FileExtension, IsPdf = ispdf, IsExcel = isExcel, IsJpeg = isJpeg, IsJpg = isJpg, IsPng = isPng, IsDocx = isDocx, IsTxt = isTxt, FileName = file.FileName });

                    _fileRepository.DeleteFile(new DeleteFileInputModel() { FileId = file.FileId, TimeStamp = file.TimeStamp }, loggedInContext, validationMessages);
                }
            }
            string subject = "";
            if(grERomandeInput.IsGre == true)
            {
                subject = "Facture " + grERomandeInput.Month.ToString("MMMM-yy", new System.Globalization.CultureInfo("fr-FR")) + " Photon One";
            }
            else
            {
                subject = "Facture " + grERomandeInput.Term + " " + grERomandeInput.Month.ToString("yy", new System.Globalization.CultureInfo("fr-FR")) + " Photon One";
            }

            var toMails = new string[1];
            toMails[0] = siteoutputModel.Email;
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpServer = smtpDetails?.SmtpServer,
                SmtpServerPort = smtpDetails?.SmtpServerPort,
                SmtpMail = smtpDetails?.SmtpMail,
                SmtpPassword = smtpDetails?.SmtpPassword,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = subject,
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                MailAttachmentsWithFileType = fileStream,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);
        }

        public Guid? UpsertTVA(TVAInputModel tvaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTVA", "tvaInput", tvaInput, "GroupeERomande Service"));

            tvaInput.Id = _groupeRepository.UpsertTVA(tvaInput, loggedInContext, validationMessages);

            LoggingManager.Debug(tvaInput.Id?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertTVACommandId, tvaInput, loggedInContext);

            return tvaInput.Id;
        }

        public List<TVASearchOutputModel> GetTVA(GrERomandeSearchInputModel grERomandeSearchInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetGroupe", "grERomandeSearchInput", grERomandeSearchInput, "GroupeERomande Service"));

            _auditService.SaveAudit(AppCommandConstants.GetTVACommandId, grERomandeSearchInput, loggedInContext);

            return _groupeRepository.GetTVA(grERomandeSearchInput, loggedInContext, validationMessages);
        }

        private CloudBlobDirectory SetupCompanyFileContainer(CompanyOutputModel companyModel, int moduleTypeId, Guid loggedInUserId, string storageAccountName)
        {
            LoggingManager.Info("SetupCompanyFileContainer");

            CloudStorageAccount storageAccount = StorageAccount(storageAccountName);

            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();

            Regex re = new Regex(@"(^{[&\/\\#,+()$~%._\'"":*?<>{}@`;^=-]})$");

            companyModel.CompanyName = companyModel.CompanyName.Replace(" ", string.Empty);

            re.Replace(companyModel.CompanyName, "");

            string company = (companyModel.CompanyId.ToString()).ToLower();

            CloudBlobContainer container = blobClient.GetContainerReference(company);

            try
            {
                bool isCreated = container.CreateIfNotExists();

                if (isCreated)
                {
                    container.SetPermissions(new BlobContainerPermissions
                    {
                        PublicAccess = BlobContainerPublicAccessType.Blob
                    });
                }
            }
            catch (StorageException e)
            {
                Console.WriteLine(e.Message);

                throw;
            }

            string directoryReference = moduleTypeId == (int)ModuleTypeEnum.Hrm ? AppConstants.HrmBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Assets ? AppConstants.AssetsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.FoodOrder ? AppConstants.FoodOrderBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Projects ? AppConstants.ProjectsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Invoices ? AppConstants.ProjectsBlobDirectoryReference : AppConstants.LocalBlobContainerReference;

            CloudBlobDirectory moduleDirectory = container.GetDirectoryReference(directoryReference);

            CloudBlobDirectory userLevelDirectory = moduleDirectory.GetDirectoryReference(loggedInUserId.ToString());

            return userLevelDirectory;
        }

        private CloudStorageAccount StorageAccount(string storageAccountName)
        {
            LoggingManager.Debug("Entering into GetStorageAccount method of blob service");
            string account;
            if (string.IsNullOrEmpty(storageAccountName))
            {
                account = CloudConfigurationManager.GetSetting("StorageAccountName");
            }
            else
            {
                account = storageAccountName;
            }

            string key = CloudConfigurationManager.GetSetting("StorageAccountAccessKey");
            string connectionString = $"DefaultEndpointsProtocol=https;AccountName={account};AccountKey={key}";
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(connectionString);

            LoggingManager.Debug("Exit from GetStorageAccount method of blob service");

            return storageAccount;
        }

        public Guid? UpsertEntryFormField(EntryFormUpsertInputModel entryFormInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTVA", "entryFormInput", entryFormInput, "GroupeERomande Service"));

            if (!GroupeERomandeValidationHelper.UpsertEntryFormFieldValidation(entryFormInput, loggedInContext, validationMessages))
            {
                return null;
            }
            entryFormInput.FieldName = entryFormInput.DisplayName.Replace(" ", "");
            entryFormInput.GRDId = null;


            entryFormInput.EntryFormId = _groupeRepository.UpsertEntryFormField(entryFormInput, loggedInContext, validationMessages);

            LoggingManager.Debug(entryFormInput.EntryFormId?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertTVACommandId, entryFormInput, loggedInContext);

            return entryFormInput.EntryFormId;
        }

        public List<EntryFormFieldReturnOutputModel> GetEntryFormField(EntryFormFieldSearchInputModel entryFormSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetGroupe", "grERomandeSearchInput", entryFormSearchInputModel, "GroupeERomande Service"));

            _auditService.SaveAudit(AppCommandConstants.GetTVACommandId, entryFormSearchInputModel, loggedInContext);

            return _groupeRepository.GetEntryFormField(entryFormSearchInputModel, loggedInContext, validationMessages);
        }

        public Guid? UpsertMessageFieldType(MessageFieldTypeOutputModel entryFormInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTVA", "entryFormInput", entryFormInput, "GroupeERomande Service"));

            if (!GroupeERomandeValidationHelper.UpsertMessageFieldValidation(entryFormInput, loggedInContext, validationMessages))
            {
                return null;
            }
            

            entryFormInput.MessageId = _groupeRepository.UpsertMessagefieldType(entryFormInput, loggedInContext, validationMessages);

            LoggingManager.Debug(entryFormInput.MessageId?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertTVACommandId, entryFormInput, loggedInContext);

            return entryFormInput.MessageId;
        }

        public List<MessageFieldTypeOutputModel> GetMessageFieldType(MessageFieldSearchInputModel entryFormSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMessageFieldType", "grERomandeSearchInput", entryFormSearchInputModel, "GroupeERomande Service"));

            _auditService.SaveAudit(AppCommandConstants.GetTVACommandId, entryFormSearchInputModel, loggedInContext);

            return _groupeRepository.GetMessageFieldType(entryFormSearchInputModel, loggedInContext, validationMessages);
        }

        public Guid? UpsertEntryFormFieldType(FieldTypeSearchModel fieldTypeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEntryFormFieldType", "fieldTypeInput", fieldTypeInput, "GroupeERomande Service"));

            if (!GroupeERomandeValidationHelper.UpsertEntryFormFieldTypeValidation(fieldTypeInput, loggedInContext, validationMessages))
            {
                return null;
            }

            fieldTypeInput.Id = _groupeRepository.UpsertEntryFormFieldType(fieldTypeInput, loggedInContext, validationMessages);

            LoggingManager.Debug(fieldTypeInput.Id?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertTVACommandId, fieldTypeInput, loggedInContext);

            return fieldTypeInput.Id;
        }

        public List<FieldTypeSearchModel> GetEntryFormFieldType(FieldTypeSearchModel entryFormFieldSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetGroupe", "grERomandeSearchInput", entryFormFieldSearchInputModel, "GroupeERomande Service"));

            _auditService.SaveAudit(AppCommandConstants.GetTVACommandId, entryFormFieldSearchInputModel, loggedInContext);

            return _groupeRepository.GetEntryFormFieldType(entryFormFieldSearchInputModel, loggedInContext, validationMessages);
        }

        public List<GreRomandeHistoryOutputModel> GetGroupeRomandeHistory(GrERomandeSearchInputModel groupERomandeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetGroupeRomandeHistory", "grERomandeSearchInput", groupERomandeSearchInputModel, "GroupeERomande Service"));

            _auditService.SaveAudit(AppCommandConstants.GetTVACommandId, groupERomandeSearchInputModel, loggedInContext);

            return _groupeRepository.GetGroupeRomandeHistory(groupERomandeSearchInputModel, loggedInContext, validationMessages);
        }

        public Guid? UpdateGreRomonadeHistory(GrERomandeInputModel grERomandeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEntryFormFieldType", "grERomandeInput", grERomandeInput, "GroupeERomande Service"));

            
            Guid? Id = _groupeRepository.UpdateGreRomandeHistory(grERomandeInput.HistoryId, loggedInContext, validationMessages);

            LoggingManager.Debug(Id?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertTVACommandId, grERomandeInput, loggedInContext);

            CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
            companySettingsSearchInputModel.CompanyId = companyModel?.CompanyId;
            companySettingsSearchInputModel.IsSystemApp = null;
            string storageAccountName = string.Empty;

            List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
            if (companySettings.Count > 0)
            {
                var storageAccountDetails = companySettings.Where(x => x.Key == "StorageAccountName").FirstOrDefault();
                storageAccountName = storageAccountDetails?.Value;
            }

            var directory = SetupCompanyFileContainer(companyModel, 6, loggedInContext.LoggedInUserId, storageAccountName);

            string url = grERomandeInput.InvoiceUrl;
            string fileName = url.Substring(url.LastIndexOf("/") + 1);

            CloudBlockBlob blockBlob = directory.GetBlockBlobReference(fileName);
            blockBlob.DeleteIfExists();

            return Id;
        }
    }
}
