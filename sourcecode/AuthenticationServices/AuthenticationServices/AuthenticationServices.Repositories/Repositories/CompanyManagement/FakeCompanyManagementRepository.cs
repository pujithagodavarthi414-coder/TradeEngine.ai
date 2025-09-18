using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.CompanyStructure;
using AuthenticationServices.Models.HrManagement;
using AuthenticationServices.Models.MasterData;
using AuthenticationServices.Models.Modules;
using System;
using System.Collections.Generic;

namespace AuthenticationServices.Repositories.Repositories.CompanyManagement
{
    public class FakeCompanyManagementRepository : ICompanyManagementRepository
    {
        public List<CompanyOutputModel> SearchCompanies(CompanySearchCriteriaInputModel companySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<CompanyOutputModel> companies = GetListOfCompanies();

            var filteredCompany = new List<CompanyOutputModel>();

            if (companySearchCriteriaInputModel.CompanyId != null || companySearchCriteriaInputModel.IndustryId != null || companySearchCriteriaInputModel.MainUseCaseId != null || companySearchCriteriaInputModel.CountryId != null || companySearchCriteriaInputModel.CurrencyId != null ||
                companySearchCriteriaInputModel.NumberFormatId != null || companySearchCriteriaInputModel.DateFormatId != null || companySearchCriteriaInputModel.TimeFormatId != null || !String.IsNullOrEmpty(companySearchCriteriaInputModel.SearchText))
            {
                foreach (var company in companies)
                {
                    if (company.CompanyId == companySearchCriteriaInputModel.CompanyId || company.IndustryId == companySearchCriteriaInputModel.IndustryId || company.MainUseCaseId == companySearchCriteriaInputModel.MainUseCaseId || company.CountryId == companySearchCriteriaInputModel.CountryId
                        || company.CurrencyId == companySearchCriteriaInputModel.CurrencyId || company.NumberFormatId == companySearchCriteriaInputModel.NumberFormatId || company.DateFormatId == companySearchCriteriaInputModel.DateFormatId ||
                        company.TimeFormatId == companySearchCriteriaInputModel.TimeFormatId || (!string.IsNullOrEmpty(companySearchCriteriaInputModel.SearchText) && (company.CompanyName.ToLower().Contains(companySearchCriteriaInputModel.SearchText.ToLower()) 
                        || company.WorkEmail.ToLower().Contains(companySearchCriteriaInputModel.SearchText.ToLower()) ||
                        company.PhoneNumber.ToLower().Contains(companySearchCriteriaInputModel.SearchText.ToLower()) || company.SiteAddress.ToLower().Contains(companySearchCriteriaInputModel.SearchText.ToLower()) ||
                        company.TeamSize.ToString().Contains(companySearchCriteriaInputModel.SearchText.ToLower()) )) )
                    {
                        filteredCompany.Add(company);
                    }
                }
                return filteredCompany;
            }

            return companies;
        }

        public List<CompanyModuleOutputModel> GetCompanyModules(CompanyModuleSearchInputModel companySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<CompanyModuleOutputModel> companies = GetListOfCompanyModules();

            var filteredCompany = new List<CompanyModuleOutputModel>();

            if (companySearchCriteriaInputModel.CompanyId != null ||  !String.IsNullOrEmpty(companySearchCriteriaInputModel.SearchText))
            {
                foreach (var company in companies)
                {
                    if (company.CompanyId == companySearchCriteriaInputModel.CompanyId || (!string.IsNullOrEmpty(companySearchCriteriaInputModel.SearchText) && (company.ModuleName.ToLower().Contains(companySearchCriteriaInputModel.SearchText.ToLower()))))
                    {
                        filteredCompany.Add(company);
                    }
                }
                return filteredCompany;
            }

            return companies;
        }

        public CompanyOutputModel GetCompanyDetails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<CompanyOutputModel> companies = GetListOfCompanies();

            foreach (var company in companies)
            {
                if (company.CompanyId == loggedInContext.CompanyGuid)
                {
                    return company;
                }
            }

            return null;
        }

        public Guid? DeleteCompanyModule(DeleteCompanyModuleModel deleteCompanyModuleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return deleteCompanyModuleModel.CompanyModuleId;
        }

        public Guid? ArchiveCompany(ArchiveCompanyInputModel archiveCompanyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return archiveCompanyInputModel.CompanyId;
        }

        public List<CompanyStructureOutputModel> SearchCompanyStructure(CompanyStructureSearchCriteriaInputModel companyStructureSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            return new List<CompanyStructureOutputModel>();
        }

        public void InsertSentMail(EmailGenericModel emailGenericModel, LoggedInContext loggedInContext)
        {
            
        }

        public int GetMailsCount(LoggedInContext loggedInContext)
        {
            return 0;
        }

        public List<CompanySettingsSearchOutputModel> GetCompanySettings(CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new List<CompanySettingsSearchOutputModel>();
        }

        public string GetHtmlTemplateByName(string templateName, Guid? companyId)
        {
            return null;
        }

        public List<HtmlTemplateApiReturnModel> GetHtmlTemplates(HtmlTemplateSearchInputModel htmlTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new List<HtmlTemplateApiReturnModel>();
        }

        public void CheckUpsertCompanyValidations(CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {

        }

        public UpsertCompanyOutputModel UpsertCompany(CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            return new UpsertCompanyOutputModel() {
                CompanyId = new Guid("99DD4149-C0FB-464B-99BA-8D6D9E09982C"),
                UserId = new Guid("D4D05DD5-7E68-4A0B-9D5D-0E632C0D6E08")
            };
        }

        public bool UpdateCompanySettings(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return false;
        }

        public Guid? UpsertCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return null;
        }

        public string UpdateCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return "99DD4149-C0FB-464B-99BA-8D6D9E09982C";
        }
        public Guid? DeleteCompanyTestData(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return null;
        }
        private List<CompanyOutputModel> GetListOfCompanies()
        {
            List<CompanyOutputModel> companies = new List<CompanyOutputModel>();

            var company = new CompanyOutputModel()
            {
                CompanyId = new Guid("99DD4149-C0FB-464B-99BA-8D6D9E09982C"),
                CompanyName = "Organization 1",
                SiteAddress = "organization1.co.in",
                WorkEmail = "abc@organization1.com",
                IndustryId = new Guid("17EE5277-4885-452D-9663-1D7B4BB0A424"),
                MainUseCaseId = new Guid("6FE7FADA-2F06-49D0-8FBC-60887CEB4367"),
                TeamSize = 20,
                PhoneNumber = "0123456789",
                CountryId = new Guid("6FE7FADA-2F06-49D0-8FBC-60887CEB4367"),
                TimeZoneId = new Guid("E04A7C38-0330-4AE5-AD14-222C23F096FF"),
                CurrencyId = new Guid("C66A7AA9-5983-42A7-A2B9-9AE04FEA9114"),
                NumberFormatId = new Guid("87FA513F-5D74-4709-9A81-1069839CD625"),
                DateFormatId = new Guid("964CDD56-24B7-4CCD-9833-BFA976E61525"),
                TimeFormatId = new Guid("E2C65997-3DEA-4E71-BCFE-0CDC83380561"),
                IsRemoteAccess = 1,
                IsDemoData = false,
                NoOfPurchasedLicences = 20,
                LanCode = "en"
            };
            companies.Add(company);

            company = new CompanyOutputModel()
            {
                CompanyId = new Guid("8E24EB64-0637-4472-B497-062E118EA0A7"),
                CompanyName = "Organization 2",
                SiteAddress = "organization2.co.in",
                WorkEmail = "abc@organization2.com",
                IndustryId = new Guid("5C166739-6113-4CF3-AB13-7E9C67DD778E"),
                MainUseCaseId = new Guid("8AAE72A1-8609-4A55-B429-7A50D4C0762E"),
                TeamSize = 30,
                PhoneNumber = "0123456780",
                CountryId = new Guid("6E3B59BF-4788-4415-B95D-6859201C672E"),
                TimeZoneId = new Guid("ADE87848-5688-496B-85D9-1B4B401AE869"),
                CurrencyId = new Guid("5652A0F4-7DED-4E85-AA18-41C960A20D50"),
                NumberFormatId = new Guid("AA757552-0AEF-4FF6-99BE-0C849BA97E81"),
                DateFormatId = new Guid("4678C00D-2D48-43B4-8003-C58288427288"),
                TimeFormatId = new Guid("77F280DB-1F57-4865-9CE9-C6652229B5AC"),
                IsRemoteAccess = 0,
                IsDemoData = true,
                NoOfPurchasedLicences = 30,
                LanCode = "en"
            };
            companies.Add(company);

            company = new CompanyOutputModel()
            {
                CompanyId = new Guid("337B3857-4A3F-4ED8-B728-7997A2B1390E"),
                CompanyName = "Organization 3",
                SiteAddress = "organization3.co.in",
                WorkEmail = "abc@organization3.com",
                IndustryId = new Guid("96C2B0E5-865A-49E4-98C0-9E56484740B7"),
                MainUseCaseId = new Guid("A357AD73-8A60-4AD1-9319-3D3FD8CE6630"),
                TeamSize = 25,
                PhoneNumber = "0123456708",
                CountryId = new Guid("4464EFFF-CCBB-4747-97C4-80BCCAA1CFEA"),
                TimeZoneId = new Guid("4BA62BEF-57D8-4679-B0E1-16BEE87FC044"),
                CurrencyId = new Guid("9A761AC0-1313-4D7F-8666-6FB31556EFD0"),
                NumberFormatId = new Guid("567A469E-02D4-42BA-BA5B-702FADAECA62"),
                DateFormatId = new Guid("7176F26D-8E00-4736-9F1A-556F547B1692"),
                TimeFormatId = new Guid("01C1BB0F-641F-41AD-8341-C3030A02DD29"),
                IsRemoteAccess = 1,
                IsDemoData = true,
                NoOfPurchasedLicences = 25,
                LanCode = "en"
            };
            companies.Add(company);

            return companies;
        }

        private List<CompanyModuleOutputModel> GetListOfCompanyModules()
        {
            List<CompanyModuleOutputModel> companies = new List<CompanyModuleOutputModel>();

            var company = new CompanyModuleOutputModel()
            {
                CompanyId = new Guid("99DD4149-C0FB-464B-99BA-8D6D9E09982C"),
                CompanyName = "Organization 1",
                ModuleName = "Forms",
                ModuleId = new Guid("317FA168-F501-444C-B1C5-14C598DC18F3")
            };
            companies.Add(company);

            company = new CompanyModuleOutputModel()
            {
                CompanyId = new Guid("99DD4149-C0FB-464B-99BA-8D6D9E09982C"),
                CompanyName = "Organization 1",
                ModuleName = "Settings",
                ModuleId = new Guid("991FA5E4-D85B-4F1C-9970-33625164327A")
            };
            companies.Add(company);

            company = new CompanyModuleOutputModel()
            {
                CompanyId = new Guid("99DD4149-C0FB-464B-99BA-8D6D9E09982C"),
                CompanyName = "Organization 1",
                ModuleName = "Status reporting",
                ModuleId = new Guid("9B2B922B-EF24-420F-AECE-5DF01E2FFC7F")
            };
            companies.Add(company);

            return companies;
        }

        public Guid? UpsertModule(ModuleUpsertInputModel moduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return moduleInputModel.ModuleId;
        }

        public Guid? UpsertModulePage(ModulePageUpsertInputModel moduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new Guid();
        }

        public List<ModulePageOutputReturnModel> GetModulePages(ModulePageSearchInputModel modulePageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new List<ModulePageOutputReturnModel>();
        }

        public Guid? UpsertModuleLayout(ModuleLayoutUpsertInputModel moduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new Guid();
        }

        public List<ModuleLayoutOutputReturnModel> GetModuleLayouts(ModulePageSearchInputModel modulePageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new List<ModuleLayoutOutputReturnModel>();
        }

        public List<ModuleOutputModel> GetModules(ModuleSearchInputModel moduleSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return  new List<ModuleOutputModel>();
        }

        public Guid? UpsertCompanyModules(CompanyModuleUpsertModel companyModuleUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new Guid();
        }
    }
}
