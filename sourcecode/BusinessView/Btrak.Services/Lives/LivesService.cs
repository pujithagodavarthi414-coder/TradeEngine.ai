using System;
using Btrak.Services.FormDataServices;
using Btrak.Services.Email;
using BTrak.Common;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Lives;
using Newtonsoft.Json;
using Btrak.Models.TradeManagement;
using System.Linq;
using Btrak.Models.FormDataServices;
using Btrak.Models.User;
using Btrak.Services.User;
using Btrak.Models.BillingManagement;
using Btrak.Services.BillingManagement;
using Btrak.Models.CompanyStructure;
using Btrak.Services.CompanyStructure;
using System.Web;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models.SystemManagement;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using Btrak.Models.GenericForm;
using Btrak.Services.CustomApplication;
using DocumentFormat.OpenXml;
using System.Configuration;
using Btrak.Services.GenericForm;
using Btrak.Services.Helpers;
using System.Data;
using Btrak.Models.CompanyStructureManagement;
using Btrak.Services.CompanyStructureManagement;
using System.Dynamic;
using Newtonsoft.Json.Linq;

namespace Btrak.Services.Lives
{
    public class LivesService : ILivesService
    {
        private readonly IDataSourceService _dataSourceService;
        private readonly IEmailService _emailService;
        private readonly IDataSetService _dataSetService;
        private readonly LivesRepository _livesRepository;
        private readonly ClientRepository _clientRepository;
        private readonly UserRepository _userRepository;
        private readonly IClientService _clientService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly ICompanyStructureManagementService _companyStructureManagementService;
        private readonly IUserService _userService;
        private readonly ICustomApplicationService _customApplicationService;
        private readonly IGenericFormService _genericFormService;

        public LivesService(IDataSourceService dataSourceService, IEmailService emailService, IDataSetService dataSetService, LivesRepository livesRepository
           , UserRepository userRepository, IClientService clientService, ICompanyStructureService companyStructureService,
            IUserService userService, ICustomApplicationService customApplicationService, IGenericFormService genericFormService,ICompanyStructureManagementService companyStructureManagement
            , ClientRepository clientRepository)
        {
            _dataSourceService = dataSourceService;
            _emailService = emailService;
            _dataSetService = dataSetService;
            _livesRepository = livesRepository;
            _userRepository = userRepository;
            _clientService = clientService;
            _companyStructureService = companyStructureService;
            _userService = userService;
            _clientService = clientService;
            _companyStructureService = companyStructureService;
            _customApplicationService = customApplicationService;
            _genericFormService = genericFormService;
            _clientRepository = clientRepository;
            _companyStructureManagementService = companyStructureManagement;
        }

        public List<BasicProgramOutputModel> GetProgramBasicDetails(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProgramBasicDetails", "LivesService"));

            LoggingManager.Debug(programSearchInputModel.ToString());

            List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "Template",
                KeyValue = "Programs",
                Type = "string"
            });

            string paramsJsonModel = JsonConvert.SerializeObject(paramsJsons);

            var dataSetsResult = _dataSetService.SearchLivesDataSets(programSearchInputModel.DataSetId, null, null, paramsJsonModel, programSearchInputModel.IsArchived, programSearchInputModel.IsPagingRequired, programSearchInputModel.PageNumber, programSearchInputModel.PageSize, loggedInContext, validationMessages).GetAwaiter().GetResult()?.OrderBy(s => s.CreatedDateTime);

            List<BasicProgramOutputModel> basicProgramOutputModels = new List<BasicProgramOutputModel>();

            basicProgramOutputModels = dataSetsResult?.Select(e => new BasicProgramOutputModel
            {
                ProgramId = e.Id,
                DataSourceId = e.DataSourceId,
                Image = e.DataJson.Image,
                FormData = e.DataJson.FormData,
                UserIds = e.DataJson.UserIds,
                ProgramName = e.DataJson.ProgramName,
                ProjectPeriod = e.DataJson.ProjectPeriod,
                CreatedBy = e.CreatedByUserId,
                Template = e.DataJson.Template,
                CountryId = e.DataJson.CountryId,
                ProgramUniqueId = e.DataJson.ProgramUniqueId,
                ImageUrl = e.DataJson.ImageUrl
            }).ToList();

            return basicProgramOutputModels;

        }

        public Guid? UpsertLivesProgram(ProgramUpsertModel programUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertLivesProgram", "Lives Service"));

            LoggingManager.Debug(programUpsertModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            if (!CommonValidationHelper.ValidateDynamicField(programUpsertModel.ProgramName, "ProgramName", loggedInContext, validationMessages))
            {
                return null;
            }

            if (!CommonValidationHelper.ValidateDynamicField(programUpsertModel.DataSourceId == Guid.Empty ? null : programUpsertModel.DataSourceId.ToString(), "DataSource", loggedInContext, validationMessages))
            {
                return null;
            }

            if (!CommonValidationHelper.ValidateDynamicField(programUpsertModel.Template, "Template", loggedInContext, validationMessages))
            {
                return null;
            }

            string programUniqueId = programUpsertModel.ProgramUniqueId;

            dynamic formData = new ExpandoObject();
            formData = programUpsertModel.FormData;
            var test = JObject.Parse(formData);
            string countryId = test["country"];

            //new record
            if ( countryId != null && countryId != string.Empty && programUpsertModel.IsNewRecord == true)
            {
                var countryApiReturn = _companyStructureManagementService.GetCountries(new CountrySearchInputModel() { IsArchived = false, CountryId = Guid.Parse(countryId) }, validationMessages, loggedInContext)?.FirstOrDefault();

                string value = _dataSetService.SearchDynamicDataSetsWithReference(null, null, null, null, null, null, null, null, "ProgramUniqueId", countryApiReturn.CountryId, loggedInContext, validationMessages);

                long programId = long.Parse(value == null || value == string.Empty ? "0" : value.Remove(0, 3)) + 1;

                programUniqueId = countryApiReturn.CountryName.Substring(0, 2) + "-" + String.Format("{0:D5}", programId); 
            } 
            else
            {
                ProgramSearchInputModel programSearchInputModel = new ProgramSearchInputModel()
                {
                    ProgramId = programUpsertModel.Id
                };
                var programDetails = GetProgramBasicDetails(programSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();
                var form = JObject.Parse(programDetails.FormData?.ToString());
                string country = form["country"].ToString();
                //removing exisiting record countryId
                if(country != null && country != string.Empty && (countryId == null || countryId == string.Empty))
                {
                    programUniqueId = null;
                }
                //existing record edit(initially no country selected)
                else if(countryId != null && countryId != string.Empty && (country == null || country == string.Empty))
                {
                    var countryApiReturn = _companyStructureManagementService.GetCountries(new CountrySearchInputModel() { IsArchived = false, CountryId = Guid.Parse(countryId) }, validationMessages, loggedInContext)?.FirstOrDefault();

                    string value = _dataSetService.SearchDynamicDataSetsWithReference(null, null, null, null, null, null, null, null, "ProgramUniqueId", countryApiReturn.CountryId, loggedInContext, validationMessages);

                    long programId = long.Parse(value == null || value == string.Empty ? "0" : value.Remove(0, 3)) + 1;

                    programUniqueId = countryApiReturn.CountryName.Substring(0, 2) + "-" + String.Format("{0:D5}", programId);
                }
                //existing record edit(initially country selected)
                else if(countryId != null && countryId != string.Empty && country != null && country != string.Empty && countryId != country)
                {
                    var countryApiReturn = _companyStructureManagementService.GetCountries(new CountrySearchInputModel() { IsArchived = false, CountryId = Guid.Parse(countryId) }, validationMessages, loggedInContext)?.FirstOrDefault();

                    string value = _dataSetService.SearchDynamicDataSetsWithReference(null, null, null, null, null, null, null, null, "ProgramUniqueId", countryApiReturn.CountryId, loggedInContext, validationMessages);

                    long programId = long.Parse(value == null || value == string.Empty ? "0" : value.Remove(0, 3)) + 1;

                    programUniqueId = countryApiReturn.CountryName.Substring(0, 2) + "-" + String.Format("{0:D5}", programId);
                }

            }

            //if (programUniqueId != null)
            //{
            //test.ProgramUniqueId = programUniqueId;
            //formData = JsonConvert.SerializeObject(test);
            //}


            ProgramDataSetUpsertModel programDataSetUpsertModel = new ProgramDataSetUpsertModel();
            programDataSetUpsertModel.FormData = formData;
            programDataSetUpsertModel.Template = programUpsertModel.Template;
            programDataSetUpsertModel.ProgramName = programUpsertModel.ProgramName;
            programDataSetUpsertModel.ProjectPeriod = programUpsertModel.ProjectPeriod;
            programDataSetUpsertModel.Location = programUpsertModel.Location;
            programDataSetUpsertModel.UserIds = programUpsertModel.UserIds;
            programDataSetUpsertModel.TemplateTypeId = programUpsertModel.TemplateTypeId;

            if (countryId != null)
            {
                programDataSetUpsertModel.CountryId = Guid.Parse(countryId);
            }

            programDataSetUpsertModel.ImageUrl = programUpsertModel.ImageUrl;
            programDataSetUpsertModel.ProgramUniqueId = programUniqueId;
            DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();
            dataSetUpsertInputModel.IsArchived = programUpsertModel.IsArchived;
            dataSetUpsertInputModel.DataJson = JsonConvert.SerializeObject(programDataSetUpsertModel);
            dataSetUpsertInputModel.CompanyId = loggedInContext.CompanyGuid;
            dataSetUpsertInputModel.DataSourceId = programUpsertModel.DataSourceId;
            dataSetUpsertInputModel.Id = programUpsertModel.Id;
            dataSetUpsertInputModel.IsNewRecord = programUpsertModel.IsNewRecord;
            Guid? result;

            if (programUpsertModel.IsNewRecord == true)
            {
                result = _dataSetService.CreateUserDataSetRelation(dataSetUpsertInputModel, "CreateDataSet", loggedInContext, validationMessages).GetAwaiter().GetResult();
            }
            else
            {
                result = _dataSetService.CreateUserDataSetRelation(dataSetUpsertInputModel, "UpdateDataSet", loggedInContext, validationMessages).GetAwaiter().GetResult();
            }

            return result;
        }

        public Guid? UpsertESGIndicators(ESGIndicatorsInputModel eSGIndicatorsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertLivesProgram", "Lives Service"));

            LoggingManager.Debug(eSGIndicatorsInputModel.ToString());

            if (!CommonValidationHelper.ValidateDynamicField(eSGIndicatorsInputModel.ProgramId == Guid.Empty ? null : eSGIndicatorsInputModel.DataSourceId.ToString(), "Program", loggedInContext, validationMessages))
            {
                return null;
            }

            if (!CommonValidationHelper.ValidateDynamicField(eSGIndicatorsInputModel.Template, "Template", loggedInContext, validationMessages))
            {
                return null;
            }

            ESGIndicatorDataSetUpsertModel eSGIndicatorDataSetUpsert = new ESGIndicatorDataSetUpsertModel();
            eSGIndicatorDataSetUpsert.FormData = eSGIndicatorsInputModel.FormData;
            eSGIndicatorDataSetUpsert.Template = eSGIndicatorsInputModel.Template;
            eSGIndicatorDataSetUpsert.ProgramId = eSGIndicatorsInputModel.ProgramId;

            DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();
            dataSetUpsertInputModel.IsArchived = eSGIndicatorsInputModel.IsArchived;
            dataSetUpsertInputModel.DataJson = JsonConvert.SerializeObject(eSGIndicatorDataSetUpsert);
            dataSetUpsertInputModel.CompanyId = loggedInContext.CompanyGuid;
            dataSetUpsertInputModel.DataSourceId = eSGIndicatorsInputModel.DataSourceId;
            dataSetUpsertInputModel.Id = eSGIndicatorsInputModel.Id;
            dataSetUpsertInputModel.IsNewRecord = eSGIndicatorsInputModel.IsNewRecord;

            Guid? result;

            if (eSGIndicatorsInputModel.IsNewRecord == true)
            {
                result = _dataSetService.CreateUserDataSetRelation(dataSetUpsertInputModel, "CreateDataSet", loggedInContext, validationMessages).GetAwaiter().GetResult();
            }
            else
            {
                result = _dataSetService.CreateUserDataSetRelation(dataSetUpsertInputModel, "UpdateDataSet", loggedInContext, validationMessages).GetAwaiter().GetResult();
            }

            return result;
        }

        public List<ESGIndicatorOutputModel> GetESGIndicatorsDetails(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetESGIndicatorDetails", "LivesService"));

            LoggingManager.Debug(programSearchInputModel.ToString());

            List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "Template",
                KeyValue = "ESGIndicators",
                Type = "string"
            });

            if (programSearchInputModel.ProgramId != null)
            {
                paramsJsons.Add(new ParamsJsonModel()
                {
                    KeyName = "ProgramId",
                    KeyValue = programSearchInputModel.ProgramId.ToString(),
                    Type = "string"
                });

            }

            string paramsJsonModel = JsonConvert.SerializeObject(paramsJsons);

            var dataSetsResult = _dataSetService.SearchDynamicDataSets(programSearchInputModel.DataSetId, null, null, paramsJsonModel, programSearchInputModel.IsArchived, programSearchInputModel.IsPagingRequired, programSearchInputModel.PageNumber, programSearchInputModel.PageSize, loggedInContext, validationMessages);

            var result = JsonConvert.DeserializeObject<List<DataSetGenericModel<ESGIndicatorDataSetUpsertModel>>>(JsonConvert.SerializeObject(dataSetsResult));

            List<ESGIndicatorOutputModel> eSGIndicatorOutputModels = new List<ESGIndicatorOutputModel>();

            if (result != null)
            {
                foreach (var data in result)
                {
                    var eSGIndicatorOutputModel = new ESGIndicatorOutputModel();
                    eSGIndicatorOutputModel.ProgramId = data.ProgramId;
                    eSGIndicatorOutputModel.ProgramFormData = data.ProgramFormData;
                    eSGIndicatorOutputModel.Id = data.Id;
                    eSGIndicatorOutputModel.Template = data.DataJson.Template;
                    eSGIndicatorOutputModel.FormData = data.DataJson.FormData;
                    eSGIndicatorOutputModel.DataSourceId = data.DataSourceId;
                    eSGIndicatorOutputModel.CreatedDateTime = data.CreatedDateTime;
                    eSGIndicatorOutputModels.Add(eSGIndicatorOutputModel);
                };
            }

            return eSGIndicatorOutputModels;

        }

        public List<ProgramProgressOutputModel> GetProgramProgress(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProgramProgress", "LivesService"));

            LoggingManager.Debug(programSearchInputModel.ToString());

            List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "Template",
                KeyValue = "ProgramProgress",
                Type = "string"
            });

            if (programSearchInputModel.KPIType != string.Empty && programSearchInputModel.KPIType != null)
            {
                paramsJsons.Add(new ParamsJsonModel()
                {
                    KeyName = "KPIType",
                    KeyValue = programSearchInputModel.KPIType,
                    Type = "string"
                });
            }

            string paramsJsonModel = JsonConvert.SerializeObject(paramsJsons);

            var dataSetsResult = _dataSetService.SearchDynamicDataSets(null, null, null, paramsJsonModel, programSearchInputModel.IsArchived, programSearchInputModel.IsPagingRequired, programSearchInputModel.PageNumber, programSearchInputModel.PageSize, loggedInContext, validationMessages);

            var result = JsonConvert.DeserializeObject<List<DataSetGenericModel<ProgramProgressOutputModel>>>(JsonConvert.SerializeObject(dataSetsResult));

            List<ProgramProgressOutputModel> programProgressOutputModels = new List<ProgramProgressOutputModel>();

            if (result != null)
            {
                foreach (var data in result)
                {
                    data.DataJson.DataSourceId = data.DataSourceId;
                    data.DataJson.DataSetId = data.Id;
                    programProgressOutputModels.Add(data.DataJson);
                };
            }

            return programProgressOutputModels;

        }

        public Guid? UpsertValidatorDetails(ValidatorInputModel validatorInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertValidatorDetails", "Lives Service"));

            LoggingManager.Debug(validatorInputModel.ToString());
            if (!CommonValidationHelper.ValidateDynamicField(validatorInputModel.DataSetId == Guid.Empty ? null : validatorInputModel.DataSetId.ToString(), "DataSetId", loggedInContext, validationMessages))
            {
                return null;
            }
            ValidatorDataSetUpsertModel validatorDataSetUpsertModel = new ValidatorDataSetUpsertModel();
            validatorDataSetUpsertModel.FormData = validatorInputModel.FormData;
            validatorDataSetUpsertModel.Template = validatorInputModel.Template;
            validatorDataSetUpsertModel.ValidatorId = validatorInputModel.ValidatorId;

            DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();
            dataSetUpsertInputModel.IsArchived = validatorInputModel.IsArchived;
            dataSetUpsertInputModel.DataJson = JsonConvert.SerializeObject(validatorDataSetUpsertModel);
            dataSetUpsertInputModel.CompanyId = loggedInContext.CompanyGuid;
            dataSetUpsertInputModel.DataSourceId = validatorInputModel.DataSourceId;
            dataSetUpsertInputModel.Id = validatorInputModel.DataSetId;

            Guid? result;

            if (dataSetUpsertInputModel.Id != null)
            {
                result = _dataSetService.CreateUserDataSetRelation(dataSetUpsertInputModel, "UpdateDataSet", loggedInContext, validationMessages).GetAwaiter().GetResult();
            }
            else
            {
                result = _dataSetService.CreateUserDataSetRelation(dataSetUpsertInputModel, "CreateDataSet", loggedInContext, validationMessages).GetAwaiter().GetResult();
            }

            if (validatorInputModel.PerformAuditValidationAccepted)
            {
                SendValidatorPerformAuditAcceptOrRejectMailToUser(validatorInputModel, "Acceptence", null, loggedInContext, validationMessages);
                SendProgramLevelsAccessMailToValidator(validatorInputModel, loggedInContext, validationMessages);
            }
            else if (validatorInputModel.PerformAuditValidationRejected)
            {
                SendValidatorPerformAuditAcceptOrRejectMailToUser(validatorInputModel, "Rejection", validatorInputModel.ProgramOwnerId
                    , loggedInContext, validationMessages);
                SendValidatorPerformAuditAcceptOrRejectMailToUser(validatorInputModel, "Rejection", validatorInputModel.DownStreamPlayerId
                    , loggedInContext, validationMessages);
            }

            return result;
        }

        public List<ValidatorOutputModel> GetValidatorDetails(ValidatorSearchInputModel validatorSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetValidatorDetails", "LivesService"));

            LoggingManager.Debug(validatorSearchInputModel.ToString());
            if (!CommonValidationHelper.ValidateDynamicField(validatorSearchInputModel.DataSourceId == Guid.Empty ? null : validatorSearchInputModel.DataSourceId.ToString(), "DataSourceId", loggedInContext, validationMessages))
            {
                return null;
            }
            if (!CommonValidationHelper.ValidateDynamicField(validatorSearchInputModel.ValidatorId == Guid.Empty ? null : validatorSearchInputModel.ValidatorId.ToString(), "ValidatorId", loggedInContext, validationMessages))
            {
                return null;
            }
            List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "Template",
                KeyValue = "Validation",
                Type = "string"
            });

            string paramsJsonModel = JsonConvert.SerializeObject(paramsJsons);

            var dataSetsResult = _dataSetService.SearchDynamicDataSets(null, null, null, paramsJsonModel, validatorSearchInputModel.IsArchived, validatorSearchInputModel.IsPagingRequired, validatorSearchInputModel.PageNumber, validatorSearchInputModel.PageSize, loggedInContext, validationMessages);

            var result = JsonConvert.DeserializeObject<List<DataSetGenericModel<ValidatorOutputModel>>>(JsonConvert.SerializeObject(dataSetsResult));

            List<ValidatorOutputModel> validatorOutputModels = new List<ValidatorOutputModel>();

            if (result != null)
            {
                foreach (var data in result)
                {
                    data.DataJson.DataSourceId = data.DataSourceId;
                    validatorOutputModels.Add(data.DataJson);
                };
            }

            return validatorOutputModels;
        }
        public Guid? UpsertBudgetAndInvestments(BudgetAndInvestmentsInputModel budgetAndInvestmentsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertBudgetAndInvestments", "Lives Service"));

            LoggingManager.Debug(budgetAndInvestmentsInputModel.ToString());

            if (!CommonValidationHelper.ValidateDynamicField(budgetAndInvestmentsInputModel.ProgramId == Guid.Empty ? null : budgetAndInvestmentsInputModel.DataSourceId.ToString(), "Program", loggedInContext, validationMessages))
            {
                return null;
            }

            if (!CommonValidationHelper.ValidateDynamicField(budgetAndInvestmentsInputModel.Template, "Template", loggedInContext, validationMessages))
            {
                return null;
            }

            BudgetAndInvestmentsDataSetUpsertModel dataSetUpsertModel = new BudgetAndInvestmentsDataSetUpsertModel();

            dataSetUpsertModel.FormData = budgetAndInvestmentsInputModel.FormData;
            dataSetUpsertModel.Template = budgetAndInvestmentsInputModel.Template;
            dataSetUpsertModel.ProgramId = budgetAndInvestmentsInputModel.ProgramId;

            DataSetUpsertInputModel dataSetUpsertInputModels = new DataSetUpsertInputModel();
            dataSetUpsertInputModels.IsArchived = budgetAndInvestmentsInputModel.IsArchived;
            dataSetUpsertInputModels.DataJson = JsonConvert.SerializeObject(dataSetUpsertModel);
            dataSetUpsertInputModels.CompanyId = loggedInContext.CompanyGuid;
            dataSetUpsertInputModels.DataSourceId = budgetAndInvestmentsInputModel.DataSourceId;
            dataSetUpsertInputModels.Id = budgetAndInvestmentsInputModel.DataSetId;

            Guid? result;

            if (dataSetUpsertInputModels.Id != null)
            {
                result = _dataSetService.CreateUserDataSetRelation(dataSetUpsertInputModels, "UpdateDataSet", loggedInContext, validationMessages).GetAwaiter().GetResult();
            }
            else
            {
                result = _dataSetService.CreateUserDataSetRelation(dataSetUpsertInputModels, "CreateDataSet", loggedInContext, validationMessages).GetAwaiter().GetResult();
            }

            return result;
        }

        public Guid? UpsertProgramProgress(ProgramProgressInputModel programProgressInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProgramProgress", "Lives Service"));

            LoggingManager.Debug(programProgressInputModel.ToString());

            ProgramProgressDataSetUpsertModel dataSetUpsertModel = new ProgramProgressDataSetUpsertModel();

            programProgressInputModel.Template = programProgressInputModel.Template == null ? "ProgramProgress" : programProgressInputModel.Template;

            if (!CommonValidationHelper.ValidateDynamicField(programProgressInputModel.ProgramId == Guid.Empty ? null : programProgressInputModel.DataSourceId.ToString(), "Program", loggedInContext, validationMessages))
            {
                return null;
            }

            if (!CommonValidationHelper.ValidateDynamicField(programProgressInputModel.Template, "Template", loggedInContext, validationMessages))
            {
                return null;
            }

            dataSetUpsertModel.FormData = programProgressInputModel.FormData;
            dataSetUpsertModel.Template = programProgressInputModel.Template;
            dataSetUpsertModel.ProgramId = programProgressInputModel.ProgramId;
            dataSetUpsertModel.KPIType = programProgressInputModel.KPIType;
            dataSetUpsertModel.IsVerified = programProgressInputModel.IsVerified;

            DataSetUpsertInputModel dataSetUpsertInputModels = new DataSetUpsertInputModel();
            dataSetUpsertInputModels.IsArchived = programProgressInputModel.IsArchived;
            dataSetUpsertInputModels.DataJson = JsonConvert.SerializeObject(dataSetUpsertModel);
            dataSetUpsertInputModels.CompanyId = loggedInContext.CompanyGuid;
            dataSetUpsertInputModels.DataSourceId = programProgressInputModel.DataSourceId;
            dataSetUpsertInputModels.Id = programProgressInputModel.DataSetId;
            dataSetUpsertInputModels.IsNewRecord = programProgressInputModel.IsNewRecord;

            Guid? result;

            if (dataSetUpsertInputModels.Id != null && (programProgressInputModel.IsNewRecord == false || programProgressInputModel.IsNewRecord == null))
            {
                result = _dataSetService.CreateUserDataSetRelation(dataSetUpsertInputModels, "UpdateDataSet", loggedInContext, validationMessages).GetAwaiter().GetResult();
            }
            else
            {
                result = _dataSetService.CreateUserDataSetRelation(dataSetUpsertInputModels, "CreateDataSet", loggedInContext, validationMessages).GetAwaiter().GetResult();
            }

            return result;
        }

        public List<BudgetAndInvestmentsOutputModel> GetBudgetAndInvestments(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBudgetAndInvestments", "LivesService"));

            LoggingManager.Debug(programSearchInputModel.ToString());

            List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "Template",
                KeyValue = "BudgetAndInvestments",
                Type = "string"
            });

            if (programSearchInputModel.ProgramId != null)
            {
                paramsJsons.Add(new ParamsJsonModel()
                {
                    KeyName = "ProgramId",
                    KeyValue = programSearchInputModel.ProgramId.ToString(),
                    Type = "string"
                });

            }

            string paramsJsonModel = JsonConvert.SerializeObject(paramsJsons);

            var dataSetsResult = _dataSetService.SearchDynamicDataSets(programSearchInputModel.DataSetId, programSearchInputModel.DataSourceId, null, paramsJsonModel, programSearchInputModel.IsArchived, programSearchInputModel.IsPagingRequired, programSearchInputModel.PageNumber, programSearchInputModel.PageSize, loggedInContext, validationMessages);

            var result = JsonConvert.DeserializeObject<List<DataSetGenericModel<BudgetAndInvestmentsOutputModel>>>(JsonConvert.SerializeObject(dataSetsResult));

            List<BudgetAndInvestmentsOutputModel> budgetAndInvestments = new List<BudgetAndInvestmentsOutputModel>();

            if (result != null)
            {
                foreach (var data in result)
                {
                    BudgetAndInvestmentsOutputModel investmentsOutputModel = new BudgetAndInvestmentsOutputModel();
                    investmentsOutputModel = data.DataJson;
                    investmentsOutputModel.DataSourceId = data.DataSourceId;
                    investmentsOutputModel.DataSetId = data.Id;
                    investmentsOutputModel.CreatedDateTime = data.CreatedDateTime;
                    investmentsOutputModel.ProgramFormData = data.ProgramFormData;
                    budgetAndInvestments.Add(investmentsOutputModel);
                };
            }

            return budgetAndInvestments;

        }

        public Guid? UpdateShowInerestOnProgram(ProgramUpsertModel programUpsert, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateShowInerestOnProgram", "Trading Service"));

            ProgramSearchInputModel programSearchInputModel = new ProgramSearchInputModel();

            BasicProgramOutputModel basicProgramOutputModel = GetProgramBasicDetails(programSearchInputModel, loggedInContext, validationMessages)?.FirstOrDefault();

            if (!CommonValidationHelper.ValidateDynamicField(programUpsert.Id == Guid.Empty ? null : programUpsert.Id.ToString(), "DataSource", loggedInContext, validationMessages))
            {
                return null;
            }

            var dataSetUpdateModel = new UpdateDataSetJsonModel();

            dataSetUpdateModel.Id = programUpsert.Id;

            List<ParamsKeyModel> paramsModel = new List<ParamsKeyModel>();

            if (basicProgramOutputModel?.UserIds?.Count == 0 || basicProgramOutputModel?.UserIds == null)
            {
                basicProgramOutputModel.UserIds = new List<Guid>();
            }

            Btrak.Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel = new Models.User.UserSearchCriteriaInputModel();
            userSearchCriteriaInputModel.UserId = basicProgramOutputModel.CreatedBy;

            UserOutputModel userOutputModel = _userService.GetAllUsers(userSearchCriteriaInputModel, loggedInContext, validationMessages)?.FirstOrDefault();

            basicProgramOutputModel.UserIds.Add(loggedInContext.LoggedInUserId);

            paramsModel.Add(new ParamsKeyModel
            {
                KeyName = "UserIds",
                KeyValue = string.Join(",", basicProgramOutputModel.UserIds),
                Type = "List"
            });

            dataSetUpdateModel.ParamsJsonModel = paramsModel;

            _dataSetService.UpdateDataSetJson(dataSetUpdateModel, loggedInContext, validationMessages);

            string[] toEmails = null;
            string[] ccMails = null;

            var clientData = _clientRepository.GetClientByUserId(null, loggedInContext.LoggedInUserId, loggedInContext, validationMessages, null);

            toEmails = userOutputModel.Email.Trim().Split('\n');

            EmailTemplateModel emailTemplateModel = new EmailTemplateModel();
            emailTemplateModel.EmailTemplateName = "InterestedToInvestOnProgram";

            var template = _clientService.GetAllEmailTemplates(emailTemplateModel, loggedInContext, validationMessages)?.FirstOrDefault();

            CompanyThemeModel companyTheme = _companyStructureService.GetCompanyTheme(loggedInContext?.LoggedInUserId);
            CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

            siteDomain = siteDomain + "/lives/register-program";

            var html = template?.EmailTemplate?
                           .Replace("##ProgramName##", basicProgramOutputModel.ProgramName)
                           .Replace("##siteUrl##", siteDomain)
                           .Replace("##CompanyName##", clientData?.CompanyName == null? "Nxus" : clientData?.CompanyName);

            template.EmailSubject = template.EmailSubject.Replace("##ProgramName##", basicProgramOutputModel.ProgramName);

            var mobileNo = userOutputModel.MobileNo;

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpServer = smtpDetails?.SmtpServer,
                SmtpServerPort = smtpDetails?.SmtpServerPort,
                SmtpMail = smtpDetails?.SmtpMail,
                SmtpPassword = smtpDetails?.SmtpPassword,
                ToAddresses = toEmails,
                CCMails = ccMails,
                HtmlContent = html,
                Subject = template.EmailSubject != null ? template.EmailSubject : "Interest request for a program",
                MailAttachments = null,
                IsPdf = true
            };

            _emailService.SendMail(loggedInContext, emailModel);
            _emailService.SendSMS(mobileNo, "message body", loggedInContext);

            return programUpsert.Id;
        }

        public dynamic ImportProgramProgress(Guid applicationId, SpreadsheetDocument spreadSheetDocument, string fileName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            FormImportsRawModel formImportsRawModel = new FormImportsRawModel()
            {
                ApplicationId = applicationId
            };

            formImportsRawModel.Sheets = new List<ExcelSheetRawModel>();

            formImportsRawModel.Forms = new List<AppFormRawModel>();

            List<BasicProgramOutputModel> basicProgramOutputModels = GetProgramBasicDetails(new ProgramSearchInputModel(), loggedInContext, validationMessages);

            List<ProgramProgressInputModel> programProgressInputModels = new List<ProgramProgressInputModel>();

            if (formImportsRawModel?.Forms?.Count == 0)
            {

                ContractTemplateModel contractTemplateModel = new ContractTemplateModel();
                contractTemplateModel.ContractTemplateName = "";

                DataSourceOutputModel form = _dataSourceService.SearchDataSource(null, null, null, false, loggedInContext, validationMessages).GetAwaiter().GetResult()?.FirstOrDefault();

                GenericFormKeySearchInputModel genericFormKeySearchInputModel = new GenericFormKeySearchInputModel()
                {
                    GenericFormId = form.Id
                };

                var genericFormKeys = _genericFormService.GetGenericFormKey(genericFormKeySearchInputModel, loggedInContext, validationMessages).ToList();

                AppFormRawModel formRawData = new AppFormRawModel()
                {
                    FormId = form.Id,
                    FormName = form.Name,
                    LabelKeyPairs = genericFormKeys.Select(p => new FormPair()
                    {
                        Key = p.Key,
                        Label = p.Label,
                        Type = p.Type,
                        DecimalLimit = p?.DecimalLimit
                    }).ToList()
                };

                formImportsRawModel.Forms.Add(formRawData);

            }

            WorkbookPart workbookPart = spreadSheetDocument.WorkbookPart;
            List<Sheet> sheets = spreadSheetDocument.WorkbookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>().ToList();

            for (int k = 0; k < sheets.ToList().Count; k++)
            {
                ExcelSheetRawModel excelSheetRawModel = new ExcelSheetRawModel();
                string relationshipId = sheets[k].Id.Value;
                WorksheetPart worksheetPart = (WorksheetPart)spreadSheetDocument.WorkbookPart.GetPartById(relationshipId);
                Worksheet workSheet = worksheetPart.Worksheet;
                SheetData sheetData = workSheet.GetFirstChild<SheetData>();
                IEnumerable<Row> rows = sheetData.Descendants<Row>();

                var sheetHeaders = new List<string>();

                for (int i = 0; i < rows.First().Descendants<Cell>().Count(); i++)
                {
                    var header = GetCellValue(spreadSheetDocument, rows.First().Descendants<Cell>().ElementAt(i));

                    sheetHeaders.Add(header);
                }

                excelSheetRawModel.ExcelHeaders = sheetHeaders.Where(p => p != null).ToList();

                var headerRow = true;

                var formRecords = new List<FormData>();

                var formKeys = formImportsRawModel?.Forms?.FirstOrDefault()?.LabelKeyPairs?.ToList();

                foreach (Row row in rows)
                {
                    string programName = null;

                    if (!headerRow)
                    {
                        var keyValuePairs = new List<ExcelPair>();

                        var dict = new Dictionary<string, string>();

                        for (int i = 0; i < row.Descendants<Cell>().Count(); i++)
                        {
                            var value = GetCellValue(spreadSheetDocument, row.Descendants<Cell>().ElementAt(i));
                            string keyName = sheetHeaders[i].ToLower();

                            int? decimalLimit = formKeys?.Where(t => t.Label?.ToLower() == keyName?.ToLower())?.FirstOrDefault()?.DecimalLimit;

                            double cellValue = 0;

                            bool successfullyParsed = double.TryParse(value, out cellValue);

                            string type = formKeys?.Where(t => t.Label?.ToLower() == keyName?.ToLower())?.FirstOrDefault()?.Type;

                            if (type == "number" && cellValue.ToString() != value && successfullyParsed == false && formKeys != null && type != null)
                            {
                                validationMessages.Add(new ValidationMessage
                                {
                                    ValidationMessaage = "Data not matching with the key type"
                                });
                            }

                            ExcelPair tempRow = new ExcelPair
                            {
                                Key = keyName,
                                Value = cellValue == 0 || decimalLimit == null || value == null ? value : Math.Round(cellValue, (int)(decimalLimit)).ToString()
                            };

                            if (keyName.ToLower() == "programname")
                            {
                                programName = tempRow.Value;
                                continue;
                            }

                            keyValuePairs.Add(tempRow);

                            string keystring = null;

                            if (keyName != "programname")
                            {
                                keystring = formKeys?.Where(t => t.Label.ToLower() == tempRow.Key.ToLower())?.FirstOrDefault()?.Key;
                            }

                            if (keyName.ToLower() != "programname" && keystring != null)
                            {
                                dict.Add(keystring, tempRow.Value);
                            }

                            if ((formKeys == null || keystring == null) && keyName != "programname")
                            {
                                validationMessages.Add(new ValidationMessage
                                {
                                    ValidationMessaage = "Some of the fields are missing"
                                });

                                return validationMessages;
                            }

                        }

                        ProgramProgressInputModel programProgressInputModel = new ProgramProgressInputModel();
                        programProgressInputModel.ProgramId = basicProgramOutputModels?.Where(t => t.ProgramName == programName)?.FirstOrDefault()?.ProgramId;

                        if (programProgressInputModel.ProgramId == null)
                        {
                            validationMessages.Add(new ValidationMessage
                            {
                                ValidationMessaage = "One of the program name not matching"

                            });
                            return validationMessages;
                        }

                        programProgressInputModel.Template = "ProgramProgress";
                        programProgressInputModel.DataSourceId = programProgressInputModel.ProgramId;
                        programProgressInputModel.IsArchived = false;
                        programProgressInputModel.FormData = dict;
                        programProgressInputModels.Add(programProgressInputModel);

                    }
                    else
                    {
                        headerRow = false;
                    }
                }

            }

            foreach (var record in programProgressInputModels)
            {

                Guid? id = UpsertProgramProgress(record, loggedInContext, validationMessages);
            }



            return formImportsRawModel;
        }

        private string GetCellValue(SpreadsheetDocument document, Cell cell)
        {
            SharedStringTablePart stringTablePart = document.WorkbookPart.SharedStringTablePart;
            string value = cell.CellValue?.InnerXml;

            if (cell.DataType != null && cell.DataType.Value == CellValues.SharedString)
            {
                return stringTablePart.SharedStringTable.ChildElements[Int32.Parse(value)].InnerText;
            }


            if (cell.StyleIndex != null)
            {
                var cellFormat = document.WorkbookPart.WorkbookStylesPart.Stylesheet.CellFormats.ChildElements[
                    int.Parse(cell.StyleIndex.InnerText)] as CellFormat;

                if (cellFormat != null && cellFormat.NumberFormatId > 13)
                {
                    var dateFormat = GetDateTimeFormat(cellFormat.NumberFormatId);
                    if (!string.IsNullOrEmpty(dateFormat))
                    {
                        if (!string.IsNullOrEmpty(value))
                        {
                            if (double.TryParse(value, out var cellDouble))
                            {
                                var theDate = DateTime.FromOADate(cellDouble);
                                value = theDate.ToString(dateFormat);
                            }
                        }
                    }
                }
            }

            return value;
        }

        private readonly Dictionary<uint, string> DateFormatDictionary = new Dictionary<uint, string>()
        {
            [14] = "dd/MM/yyyy",
            [15] = "d-MMM-yy",
            [16] = "d-MMM",
            [17] = "MMM-yy",
            [18] = "h:mm AM/PM",
            [19] = "h:mm:ss AM/PM",
            [20] = "h:mm",
            [21] = "h:mm:ss",
            [22] = "M/d/yy h:mm",
            [30] = "M/d/yy",
            [34] = "yyyy-MM-dd",
            [45] = "mm:ss",
            [46] = "[h]:mm:ss",
            [47] = "mmss.0",
            [51] = "MM-dd",
            [52] = "yyyy-MM-dd",
            [53] = "yyyy-MM-dd",
            [55] = "yyyy-MM-dd",
            [56] = "yyyy-MM-dd",
            [58] = "MM-dd",
            [165] = "M/d/yy",
            [166] = "dd MMMM yyyy",
            [167] = "dd/MM/yyyy",
            [168] = "dd/MM/yy",
            [169] = "d.M.yy",
            [170] = "yyyy-MM-dd",
            [171] = "dd MMMM yyyy",
            [172] = "d MMMM yyyy",
            [173] = "M/d",
            [174] = "M/d/yy",
            [175] = "MM/dd/yy",
            [176] = "d-MMM",
            [177] = "d-MMM-yy",
            [178] = "dd-MMM-yy",
            [179] = "MMM-yy",
            [180] = "MMMM-yy",
            [181] = "MMMM d, yyyy",
            [182] = "M/d/yy hh:mm t",
            [183] = "M/d/y HH:mm",
            [184] = "MMM",
            [185] = "MMM-dd",
            [186] = "M/d/yyyy",
            [187] = "d-MMM-yyyy"
        };

        private string GetDateTimeFormat(UInt32Value numberFormatId)
        {
            return DateFormatDictionary.ContainsKey(numberFormatId) ? DateFormatDictionary[numberFormatId] : string.Empty;
        }

        public List<UserLevelAccessOutputModel> GetUserLevelAccess(UserLevelAccessModel userLevelAccessModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserLevelAccess", "LivesService"));
            var validationText = userLevelAccessModel.RoleIds == null ? (userLevelAccessModel.UserAutheticationId == null ?
                "UserAutheticationId" : userLevelAccessModel.ProgramId == null ? "ProgramId" : "RoleIds") : string.Empty;
            if (!CommonValidationHelper.ValidateDynamicField(userLevelAccessModel.RoleIds != null ? userLevelAccessModel.RoleIds.ToString() :
                userLevelAccessModel.UserAutheticationId != null && userLevelAccessModel.ProgramId != null ? userLevelAccessModel.UserAutheticationId.ToString()
                + userLevelAccessModel.ProgramId.ToString() : null, validationText, loggedInContext, validationMessages))
            {
                return null;
            }
            LoggingManager.Debug(userLevelAccessModel.ToString());
            if (userLevelAccessModel.UserAutheticationId != null)
            {
                var userId = _userRepository.GetUserByUserAuthenticationIdAndCompanyId(userLevelAccessModel.UserAutheticationId, loggedInContext, validationMessages);
                userLevelAccessModel.UserId = userId;
            }
            userLevelAccessModel.RoleXml = userLevelAccessModel.RoleIds != null ?
                userLevelAccessModel.RoleXml = Utilities.ConvertIntoListXml(userLevelAccessModel.RoleIds) : null;
            var userLevelAccessModels = _livesRepository.GetUserLevelAccess(userLevelAccessModel, loggedInContext, validationMessages);
            return userLevelAccessModels;
        }
        public string UpsertUserLevelAccess(UserLevelAccessModel userLevelAccessModel, string referenceText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserLevelAccess", "LivesService"));
            if (userLevelAccessModel != null)
            {
                if (!CommonValidationHelper.ValidateDynamicField(userLevelAccessModel.ProgramId == Guid.Empty ? null : userLevelAccessModel.ProgramId.ToString(), "ProgramId", loggedInContext, validationMessages))
                {
                    return null;
                }
                if (!CommonValidationHelper.ValidateDynamicField(userLevelAccessModel.LevelIds != null ? userLevelAccessModel.LevelIds.ToString() : null, "LevelIds", loggedInContext, validationMessages))
                {
                    return null;
                }
                if (!CommonValidationHelper.ValidateDynamicField(userLevelAccessModel.UserIds != null ? userLevelAccessModel.UserIds.ToString() : null, "UserIds", loggedInContext, validationMessages))
                {
                    return null;
                }
                if (!CommonValidationHelper.ValidateDynamicField(userLevelAccessModel.ReferenceText != null && userLevelAccessModel.ReferenceText != string.Empty ?
                    userLevelAccessModel.ReferenceText : null, "ReferenceText", loggedInContext, validationMessages))
                {
                    return null;
                }
                LoggingManager.Debug(userLevelAccessModel.ToString());
                userLevelAccessModel.LevelXml = Utilities.ConvertIntoListXml(userLevelAccessModel.LevelIds);
                UserLevelAccessModel userLevelCheckingInputModel = new UserLevelAccessModel();
                foreach (var userId in userLevelAccessModel.UserIds)
                {
                    userLevelAccessModel.UserId = userId;
                    userLevelCheckingInputModel = new UserLevelAccessModel()
                    {
                        UserId = userLevelAccessModel.UserId,
                        ProgramId = userLevelAccessModel.ProgramId
                    };
                    var userLevelcheckingOutputModel = _livesRepository.GetUserLevelAccess(userLevelCheckingInputModel, loggedInContext, validationMessages);
                    bool IsUserHasLevel2AccessPreviously = false;
                    bool IsUserHasLevel3AccessPreviously = false;
                    var referenceUserLevelText = string.Empty;
                    bool IsUserMaximumLevelReached = false;
                    if (userLevelcheckingOutputModel != null && userLevelcheckingOutputModel.Count > 0)
                    {
                        IsUserHasLevel2AccessPreviously = userLevelcheckingOutputModel.Any(x => x.LevelId == new Guid("98B3DA9D-2989-468F-9E12-16F1DBF97983"));
                        IsUserHasLevel3AccessPreviously = userLevelcheckingOutputModel.Any(x => x.LevelId == new Guid("8964657D-706D-472B-956A-95482C374E85"));
                    }
                    if (IsUserHasLevel3AccessPreviously &&
                        userLevelAccessModel.ReferenceText.ToLower() == new Guid("8964657D-706D-472B-956A-95482C374E85").ToString().ToLower())
                    {
                        IsUserMaximumLevelReached = true;
                    }
                    else if (IsUserHasLevel3AccessPreviously &&
                        userLevelAccessModel.ReferenceText.ToLower() == new Guid("98B3DA9D-2989-468F-9E12-16F1DBF97983").ToString().ToLower())
                    {
                        userLevelAccessModel.IsLevelRemovel = true;
                    }
                    else if (IsUserHasLevel3AccessPreviously &&
                        userLevelAccessModel.ReferenceText.ToLower() == new Guid("E78444E9-07F3-4FAA-BF91-CC1A664B54F9").ToString().ToLower())
                    {
                        userLevelAccessModel.IsLevelRemovel = true;
                    }
                    else if (IsUserHasLevel2AccessPreviously &&
                        userLevelAccessModel.ReferenceText.ToLower() == new Guid("98B3DA9D-2989-468F-9E12-16F1DBF97983").ToString().ToLower())
                    {
                        IsUserMaximumLevelReached = true;
                    }
                    else if (IsUserHasLevel2AccessPreviously &&
                        userLevelAccessModel.ReferenceText.ToLower() == new Guid("E78444E9-07F3-4FAA-BF91-CC1A664B54F9").ToString().ToLower())
                    {
                        userLevelAccessModel.IsLevelRemovel = true;
                    }
                    else if (IsUserHasLevel2AccessPreviously &&
                        userLevelAccessModel.ReferenceText.ToLower() == new Guid("8964657D-706D-472B-956A-95482C374E85").ToString().ToLower())
                    {
                        referenceUserLevelText = userLevelAccessModel.ReferenceText.ToLower();
                    }
                    else if (IsUserHasLevel2AccessPreviously == false && IsUserHasLevel3AccessPreviously == false
                        && userLevelAccessModel.ReferenceText.ToLower() == new Guid("98B3DA9D-2989-468F-9E12-16F1DBF97983").ToString().ToLower())
                    {
                        referenceUserLevelText = userLevelAccessModel.ReferenceText.ToLower();
                    }
                    else if (IsUserHasLevel2AccessPreviously == false && IsUserHasLevel3AccessPreviously == false
                        && userLevelAccessModel.ReferenceText.ToLower() == new Guid("8964657D-706D-472B-956A-95482C374E85").ToString().ToLower())
                    {
                        referenceUserLevelText = "BothLevel2AndLevel3";
                    }
                    if (IsUserMaximumLevelReached == false)
                    {
                        _livesRepository.GetUserLevelAccess(userLevelAccessModel, loggedInContext, validationMessages);
                        var clientData = _clientRepository.GetClientByUserId(null, userLevelAccessModel.UserId, loggedInContext, validationMessages, null);
                        var clientId = clientData != null ? clientData.ClientId : new Guid("54e16782-1459-4b3c-bcc7-383e0bbb3f9e");
                        if (referenceUserLevelText == new Guid("98B3DA9D-2989-468F-9E12-16F1DBF97983").ToString().ToLower())
                        {
                            SendLevelAccessMailToDownStreamPlayer(userLevelAccessModel, "KPI'S details", clientId, loggedInContext, validationMessages);
                        }
                        else if (referenceUserLevelText == new Guid("8964657D-706D-472B-956A-95482C374E85").ToString().ToLower())
                        {
                            SendLevelAccessMailToDownStreamPlayer(userLevelAccessModel, "Budget details", clientId, loggedInContext, validationMessages);
                        }
                        else if (referenceUserLevelText == "BothLevel2AndLevel3")
                        {
                            SendLevelAccessMailToDownStreamPlayer(userLevelAccessModel, "KPI'S and Budget details", clientId, loggedInContext, validationMessages);
                        }
                    }
                }
            }
            return null;
        }
        public void SendLevelAccessMailToDownStreamPlayer(UserLevelAccessModel userLevelAccessModel, string levelName, Guid? clientId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                List<UserOutputModel> usersList = _userRepository.GetUserDetailsAndCountry(userLevelAccessModel.UserId, loggedInContext, validationMessages);
                ProgramSearchInputModel programSearchInputModel = new ProgramSearchInputModel()
                {
                    ProgramId = userLevelAccessModel.ProgramId
                };
                var programDetails = GetProgramBasicDetails(programSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();
                CompanyThemeModel companyTheme = _companyStructureService.GetCompanyTheme(loggedInContext?.LoggedInUserId);
                var CompanyLogo = companyTheme.CompanyMainLogo != null ? companyTheme.CompanyMainLogo : "http://todaywalkins.com/Comp_images/Snovasys.png";
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "LivesLevelAccessTemplate", "Trading Service"));
                {
                    var toEmails = usersList[0].Email.Trim().Split('\n');
                    var mobileNo = usersList[0].CountryCode + usersList[0].MobileNo;
                    var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];
                    var RouteAddress = siteDomain + "/trading/viewcontract/" + userLevelAccessModel.Id + "/sales-contract";
                    var messageBody = $"You have been provided access to program {levelName}." + RouteAddress;
                    var bodyDescription = $"You have been provided access to program {levelName}.";
                    var subjectDescription = $"Level access for {programDetails.ProgramName}";
                    EmailTemplateModel EmailTemplateModel = new EmailTemplateModel
                    {
                        ClientId = clientId,
                        EmailTemplateName = "ProgramLevelAccessTemplate"
                    };
                    var template = _clientService.GetAllEmailTemplates(EmailTemplateModel, loggedInContext, validationMessages).ToList()[0];
                    var html = template.EmailTemplate.Replace("##BodyDescription##", bodyDescription)
                        .Replace("##SubjectDescription##", subjectDescription)
                        .Replace("##siteUrl##", RouteAddress)
                        .Replace("##CompanyLogo##", CompanyLogo);
                    var subject = template.EmailSubject.Replace("##SubjectDescription##", subjectDescription);
                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = toEmails,
                            HtmlContent = html,
                            Subject = subject,
                            MailAttachments = null,
                            IsPdf = true
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                        _emailService.SendSMS(mobileNo, messageBody, loggedInContext);
                    });
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception.Message);
            }
        }
        public void SendValidatorPerformAuditAcceptOrRejectMailToUser(ValidatorInputModel validatorInputModel, string actionType, Guid? userId, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            try
            {
                List<UserOutputModel> userList = new List<UserOutputModel>();
                var subjectDescription = string.Empty;
                var bodyDescription = string.Empty;
                var acceptOrRejectComments = string.Empty;
                List<UserOutputModel> validatorDetails = _userRepository.GetUserDetailsAndCountry(validatorInputModel.ValidatorId, loggedInContext, validationMessages);
                ProgramSearchInputModel programSearchInputModel = new ProgramSearchInputModel()
                {
                    ProgramId = validatorInputModel.ProgramId
                };
                var programDetails = GetProgramBasicDetails(programSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();
                if (actionType == "Acceptence")
                {
                    userList = _userRepository.GetUserDetailsAndCountry(validatorInputModel.ProgramOwnerId, loggedInContext, validationMessages);
                    bodyDescription = $"The {validatorDetails[0].FullName} has accepted the validator request for {programDetails.ProgramName}.Please connect for furthur details";
                    subjectDescription = $"Validation request for {programDetails.ProgramName} Accepted by {validatorDetails[0].FullName}";
                    acceptOrRejectComments = validatorInputModel.PerformAuditAcceptComments;
                }
                else if (actionType == "Rejection")
                {
                    userList = _userRepository.GetUserDetailsAndCountry(userId, loggedInContext, validationMessages);
                    bodyDescription = $"The {validatorDetails[0].FullName} has rejected the validator request for {programDetails.ProgramName}.Please connect for furthur details";
                    subjectDescription = $"Validation request for {programDetails.ProgramName} Rejected by {validatorDetails[0].FullName}";
                    acceptOrRejectComments = validatorInputModel.PerformAuditRejectComments;
                }
                CompanyThemeModel companyTheme = _companyStructureService.GetCompanyTheme(loggedInContext?.LoggedInUserId);
                var CompanyLogo = companyTheme.CompanyMainLogo != null ? companyTheme.CompanyMainLogo : "http://todaywalkins.com/Comp_images/Snovasys.png";
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidatorPerformAuditAcceptenceTemplate", "Trading Service"));
                {
                    var toEmails = userList[0].Email.Trim().Split('\n');
                    var mobileNo = userList[0].CountryCode + userList[0].MobileNo;
                    var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];
                    var RouteAddress = siteDomain + "/trading/viewcontract/" + validatorInputModel.DataSetId + "/sales-contract";
                    var messageBody = actionType == "Acceptence" ? $"The {validatorDetails[0].FullName} has accepted the validator " +
                        $"request for {programDetails.ProgramName}.Please connect for furthur details" + RouteAddress :
                        actionType == "Rejection" ? $"The {validatorDetails[0].FullName} has rejected the validator " +
                        $"request for {programDetails.ProgramName}.Please connect for furthur details" + RouteAddress :
                        string.Empty;
                    EmailTemplateModel EmailTemplateModel = new EmailTemplateModel
                    {
                        ClientId = validatorInputModel.ClientId,
                        EmailTemplateName = "ValidatorPerformAuditAcceptorRejectTemplate"
                    };
                    var template = _clientService.GetAllEmailTemplates(EmailTemplateModel, loggedInContext, validationMessages).ToList()[0];
                    var html = template.EmailTemplate.Replace("##BodyDescription##", bodyDescription)
                        .Replace("##SubjectDescription##", subjectDescription)
                        .Replace("##Comments##", acceptOrRejectComments)
                        .Replace("##siteUrl##", RouteAddress)
                        .Replace("##CompanyLogo##", CompanyLogo);
                    var subject = template.EmailSubject.Replace("##SubjectDescription##", subjectDescription);
                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = toEmails,
                            HtmlContent = html,
                            Subject = subject,
                            MailAttachments = null,
                            IsPdf = true
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                        _emailService.SendSMS(mobileNo, messageBody, loggedInContext);
                    });
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception.Message);
            }
        }
        public void SendProgramLevelsAccessMailToValidator(ValidatorInputModel validatorInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                List<UserOutputModel> userList = _userRepository.GetUserDetailsAndCountry(validatorInputModel.ValidatorId, loggedInContext, validationMessages);
                ProgramSearchInputModel programSearchInputModel = new ProgramSearchInputModel()
                {
                    ProgramId = validatorInputModel.ProgramId
                };
                var programDetails = GetProgramBasicDetails(programSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();
                CompanyThemeModel companyTheme = _companyStructureService.GetCompanyTheme(loggedInContext?.LoggedInUserId);
                var CompanyLogo = companyTheme.CompanyMainLogo != null ? companyTheme.CompanyMainLogo : "http://todaywalkins.com/Comp_images/Snovasys.png";
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidatorProgramLevelAccessTemplate", "Trading Service"));
                {
                    var toEmails = userList[0].Email.Trim().Split('\n');
                    var mobileNo = userList[0].CountryCode + userList[0].MobileNo;
                    var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];
                    var RouteAddress = siteDomain + "/trading/viewcontract/" + validatorInputModel.DataSetId + "/sales-contract";
                    var messageBody = $"You have been provided access to details of {programDetails.ProgramName}.Click here to view" + RouteAddress;
                    var bodyDescription = $"You have been provided access to details of {programDetails.ProgramName}.Click here to view";
                    var subjectDescription = $"Level access for {programDetails.ProgramName}";
                    EmailTemplateModel EmailTemplateModel = new EmailTemplateModel
                    {
                        ClientId = validatorInputModel.ClientId,
                        EmailTemplateName = "ProgramLevelAccessTemplate"
                    };
                    var template = _clientService.GetAllEmailTemplates(EmailTemplateModel, loggedInContext, validationMessages).ToList()[0];
                    var html = template.EmailTemplate.Replace("##BodyDescription##", bodyDescription)
                        .Replace("##SubjectDescription##", subjectDescription)
                        .Replace("##siteUrl##", RouteAddress)
                        .Replace("##CompanyLogo##", CompanyLogo);
                    var subject = template.EmailSubject.Replace("##SubjectDescription##", subjectDescription);
                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = toEmails,
                            HtmlContent = html,
                            Subject = subject,
                            MailAttachments = null,
                            IsPdf = true
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                        _emailService.SendSMS(mobileNo, messageBody, loggedInContext);
                    });
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception.Message);
            }
        }

        public BasicProgramOutputModel GetProgramOverviewDetails(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProgramOverviewDetails", "LivesService"));

            LoggingManager.Debug(programSearchInputModel.ToString());

            List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "Template",
                KeyValue = "Programs",
                Type = "string"
            });

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "KPIsList"
            });

            string paramsJsonModel = JsonConvert.SerializeObject(paramsJsons);

            dynamic data = _dataSetService.SearchDynamicDataSets(programSearchInputModel.ProgramId, null, null, paramsJsonModel, false, false, null, null, loggedInContext, validationMessages);

            List<DataSetLivesOutputModel> result = JsonConvert.DeserializeObject<List<DataSetLivesOutputModel>>(JsonConvert.SerializeObject(data));

            List<ESGIndicatorOutputModel> eSGIndicatorOutputModels = new List<ESGIndicatorOutputModel>();
            DataSetLivesOutputModel dataSetLivesOutput = new DataSetLivesOutputModel();
            if (result?.FirstOrDefault()?.DataJson?.KPIs != null)
            {
                dataSetLivesOutput = result?.FirstOrDefault();
                eSGIndicatorOutputModels = JsonConvert.DeserializeObject<List<ESGIndicatorOutputModel>>(JsonConvert.SerializeObject(result?.FirstOrDefault()?.DataJson?.KPIs));
            }

            BasicProgramOutputModel basicProgramOutput = new BasicProgramOutputModel();

            basicProgramOutput.ProgramId = dataSetLivesOutput.Id;
            basicProgramOutput.ProgramName = dataSetLivesOutput.DataJson.ProgramName;
            basicProgramOutput.DataSourceId = dataSetLivesOutput.DataSourceId;
            basicProgramOutput.FormData = dataSetLivesOutput.DataJson.FormData;
            basicProgramOutput.KPI1 = dataSetLivesOutput.DataJson.KPIs;
            basicProgramOutput.Template = dataSetLivesOutput.DataJson.Template;
            basicProgramOutput.Image = dataSetLivesOutput.DataJson.Image;
            basicProgramOutput.UserIds = dataSetLivesOutput.DataJson.UserIds;

            return basicProgramOutput;

        }

        public dynamic GetIndependentSmallholderCertification(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetIndependentSmallholderCertification", "LivesService"));

            LoggingManager.Debug(programSearchInputModel.ToString());

            List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "Template",
                KeyValue = "ProgramProgress",
                Type = "string"
            });

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "KPIType",
                KeyValue = programSearchInputModel.KPIType != null ? programSearchInputModel.KPIType : "KPI01",
                Type = "string"
            });

            string paramsJsonModel = JsonConvert.SerializeObject(paramsJsons);

            var data = _dataSetService.SearchDynamicDataSets(programSearchInputModel.ProgramId, null, null, paramsJsonModel, null, null, null, null, loggedInContext, validationMessages);

            List<DataSetLivesOutputModel> result = JsonConvert.DeserializeObject<List<DataSetLivesOutputModel>>(JsonConvert.SerializeObject(data));

            object formData = result?.Select(t => t.DataJson.FormData)?.ToList();

            List<DataSetLivesOutputModel> dataSetLivesOutputModels = new List<DataSetLivesOutputModel>();

            var list = JsonConvert.DeserializeObject<List<KPIReportOutputModel>>(JsonConvert.SerializeObject(formData));

            List<string> dates = new List<string>();

            dates = list?.Where(t => (t.From != null && t.To != null))?.Select(t => t.From.Value.ToString("MMM yy") + t.To.Value.ToString("-MMM yy"))?.Distinct()?.ToList();

            DataTable ordersTable = new DataTable();
            ordersTable.Columns.Add(new DataColumn { ColumnName = "Location & Respective Target SHFs" });

            foreach (string column in dates)
            {
                ordersTable.Columns.Add(new DataColumn { ColumnName = column, DataType = typeof(Double) });
            }

            List<string> locations = new List<string>();

            locations = list?.Select(t => t.locationKpi01)?.Distinct()?.ToList();

            foreach (var location in locations)
            {
                DataRow dtRow = ordersTable.NewRow();

                if (programSearchInputModel.KPIType == null)
                {
                   double totalValue =  Math.Round((double)(list?.Where(t => (t.From != null && t.To != null))?.Where(t => (t.locationKpi01 == location))?.Select(t => t.targetShFs).Sum()), 3);

                    dtRow["Location & Respective Target SHFs"] = location + ", SHFs Target - "+ totalValue.ToString() ;

                    foreach (string column in dates)
                    {
                        dtRow[column] = Math.Round((double)(list?.Where(t => (t.From != null && t.To != null))?.Where(t => (t.locationKpi01 == location && t.numberOfIndependentShFsCertified != null && t.From.Value.ToString("MMM yy") + t.To.Value.ToString("-MMM yy") == column))?.Select(t => t.numberOfIndependentShFsCertified).Sum()), 3);
                    }
                }
                else
                {
                    double totalValue = Math.Round((double)(list?.Where(t => (t.From != null && t.To != null))?.Where(t => (t.locationKpi01 == location))?.Select(t => t.numberOfIndependentShFsCertified).Sum()), 3);

                    dtRow["Location & Respective Target SHFs"] = location + ", SHFs Target - " + totalValue.ToString();

                    foreach (string column in dates)
                    {
                        dtRow[column] = Math.Round((double)(list?.Where(t => (t.From != null && t.To != null))?.Where(t => (t.locationKpi01 == location && t.numberOfIndependentShFsCertified != null && t.From.Value.ToString("MMM yy") + t.To.Value.ToString("-MMM yy") == column))?.Select(t => t.numberOfIndependentShFsCertified).Sum()), 3);
                    }
                }

                ordersTable.Rows.Add(dtRow);
            }

            return ordersTable;
        }

        public object GetKPI1CertifiedSHFsLocation(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetKPI1CertifiedSHFsLocation", "LivesService"));
            LoggingManager.Debug(programSearchInputModel.ToString());

            List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();
            LivesDashboardAPIInputModel livesDashboardAPIInputModel = new LivesDashboardAPIInputModel();

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "Template",
                KeyValue = "ProgramProgress",
                Type = "string"
            });

            if (programSearchInputModel.Location != string.Empty && programSearchInputModel.Location != null)
            {
                paramsJsons.Add(new ParamsJsonModel()
                {
                    KeyName = "FormData.locationKpi01",
                    KeyValue = programSearchInputModel.Location,//Riau,North Sumatra,Jambi
                    Type = "string"
                });
            }

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "KPIType",
                KeyValue = "KPI01",//programSearchInputModel.KPIType,
                Type = "string"
            });

            if (programSearchInputModel.IsVerified == true)
            {
                paramsJsons.Add(new ParamsJsonModel()
                {
                    KeyName = "IsVerified",
                    KeyValue = "true",
                    Type = "boolean"
                });
            }

            DateTime today = DateTime.Now;

            livesDashboardAPIInputModel.DateFrom = livesDashboardAPIInputModel.DateFrom == null ? new DateTime(today.Year, today.Month, 1).AddMonths(-9).AddYears(-1) : livesDashboardAPIInputModel.DateFrom;
            livesDashboardAPIInputModel.DateTo = livesDashboardAPIInputModel.DateTo == null ? new DateTime(today.Year, today.Month, 1).AddMonths(1).AddMinutes(-1) : livesDashboardAPIInputModel.DateTo;

            string paramsJsonModel = JsonConvert.SerializeObject(paramsJsons);
            var data = _dataSetService.SearchDynamicDataSets(programSearchInputModel.ProgramId, null, null, paramsJsonModel, null, null, null, null, loggedInContext, validationMessages);
            List<DataSetLivesOutputModel> result = JsonConvert.DeserializeObject<List<DataSetLivesOutputModel>>(JsonConvert.SerializeObject(data));

            object formData = result?.Select(t => t.DataJson.FormData)?.ToList();
            List<DataSetLivesOutputModel> dataSetLivesOutputModels = new List<DataSetLivesOutputModel>();
            var list = JsonConvert.DeserializeObject<List<TemplateModel>>(JsonConvert.SerializeObject(formData));

            List<KPIDisplayModel> displaylist = new List<KPIDisplayModel>();
            if (result != null)
            {
                var locationdata = list?.Select(k => new { k.locationKpi01, k.numberOfIndependentShFsCertified, k.targetShFs }).GroupBy(x => new { x.locationKpi01 }, (key2, group) => new { locationKpi01 = key2.locationKpi01, numberOfIndependentShFsCertified = group.Sum(k => k.numberOfIndependentShFsCertified), targetShFs = group.Sum(k => k.targetShFs) }).ToList();

                if (locationdata != null)
                {
                    foreach (var key in locationdata)
                    {
                        KPIDisplayModel obj = new KPIDisplayModel();
                        obj.Heading = "Certified SHFs " + key.locationKpi01;
                        obj.Subheading = "Percentage of SHFs certified in " + key.locationKpi01 + " Vs Total SHFs Target in Phase 01";
                        obj.Location = key.locationKpi01;
                        obj.TotalSHFPhase1 = key.targetShFs;
                        obj.SHFCertified = key.numberOfIndependentShFsCertified;
                        displaylist.Add(obj);
                    }
                }
            }
            return displaylist;
        }

        public object GetKPI2FFBProductivityPhase01Location(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetKPI2FFBProductivityPhase01Location", "LivesService"));
            LoggingManager.Debug(programSearchInputModel.ToString());

            List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();
            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "Template",
                KeyValue = "ProgramProgress",
                Type = "string"
            });

            if (programSearchInputModel.Location != string.Empty && programSearchInputModel.Location != null)
            {
                paramsJsons.Add(new ParamsJsonModel()
                {
                    KeyName = "FormData.locationKpi01",
                    KeyValue = programSearchInputModel.Location,//Riau,North Sumatra,Jambi
                    Type = "string"
                });
            }

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "KPIType",
                KeyValue = "KPI02",
                Type = "string"
            });

            if (programSearchInputModel.IsVerified == true)
            {
                paramsJsons.Add(new ParamsJsonModel()
                {
                    KeyName = "IsVerified",
                    KeyValue = "true",
                    Type = "boolean"
                });
            }

            string paramsJsonModel = JsonConvert.SerializeObject(paramsJsons);
            var data = _dataSetService.SearchDynamicDataSets(programSearchInputModel.ProgramId, null, null, paramsJsonModel, null, null, null, null, loggedInContext, validationMessages);
            List<DataSetLivesOutputModel> result = JsonConvert.DeserializeObject<List<DataSetLivesOutputModel>>(JsonConvert.SerializeObject(data));
            object formData = result?.Select(t => t.DataJson.FormData)?.ToList();
            List<DataSetLivesOutputModel> dataSetLivesOutputModels = new List<DataSetLivesOutputModel>();
            var list = JsonConvert.DeserializeObject<List<KPI2DisplayInputModel>>(JsonConvert.SerializeObject(formData));

            List<KPI2DisplayModel> locationoutput = new List<KPI2DisplayModel>();
            if (result != null)
            {
                var KPI2Outputdata = list.Select(k => new { k.numberOfIndependentShFsCertified, k.LocationKPI01, k.numberOfShFsAttended, k.From, k.To }).GroupBy(x => new { x.LocationKPI01, x.From, x.To }, (key2, group) => new { Location = key2.LocationKPI01, NumberofCamps = group.Sum(k => k.numberOfIndependentShFsCertified), NumberSHFsAttended = group.Sum(k => k.numberOfShFsAttended), Month = (key2.From.Value.ToString("MMM-") + key2.To.Value.ToString("MMM yy")) }).ToList();

                if (KPI2Outputdata != null)
                {

                    foreach (var obj in KPI2Outputdata)
                    {
                        KPI2DisplayModel output = new KPI2DisplayModel();
                        output.Month = obj.Month;
                        output.NumberofTrainingCamps = Convert.ToDouble(obj.NumberofCamps);
                        output.numberOfShFsAttended = Convert.ToDouble(obj.NumberSHFsAttended);
                        locationoutput.Add(output);
                    }
                }
            }
            return locationoutput;
        }

        public object GetKPI3LogisticalProblemLocation(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetKPI3LogisticalProblemLocation", "LivesService"));
            LoggingManager.Debug(programSearchInputModel.ToString());
            List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "Template",
                KeyValue = "ProgramProgress",
                Type = "string"
            });

            if (programSearchInputModel.Location != string.Empty && programSearchInputModel.Location != null)
            {
                paramsJsons.Add(new ParamsJsonModel()
                {
                    KeyName = "FormData.locationKpi01",
                    KeyValue = programSearchInputModel.Location,//Riau,North Sumatra,Jambi
                    Type = "string"
                });
            }

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "KPIType",
                KeyValue = "KPI03",
                Type = "string"
            });

            if (programSearchInputModel.IsVerified == true)
            {
                paramsJsons.Add(new ParamsJsonModel()
                {
                    KeyName = "IsVerified",
                    KeyValue = "true",
                    Type = "boolean"
                });
            }

            string paramsJsonModel = JsonConvert.SerializeObject(paramsJsons);
            var data = _dataSetService.SearchDynamicDataSets(programSearchInputModel.ProgramId, null, null, paramsJsonModel, null, null, null, null, loggedInContext, validationMessages);
            List<DataSetLivesOutputModel> result = JsonConvert.DeserializeObject<List<DataSetLivesOutputModel>>(JsonConvert.SerializeObject(data));
            object formData = result?.Select(t => t.DataJson.FormData)?.ToList();
            List<DataSetLivesOutputModel> dataSetLivesOutputModels = new List<DataSetLivesOutputModel>();
            var list = JsonConvert.DeserializeObject<List<KPI2DisplayInputModel>>(JsonConvert.SerializeObject(formData));

            List<KPI2DisplayModel> locationoutput = new List<KPI2DisplayModel>();
            if (result != null)
            {
                var KPI2Outputdata = list.Select(k => new { k.numberOfIndependentShFsCertified, k.LocationKPI01, k.numberOfShFsAttended, k.From, k.To }).GroupBy(x => new { x.LocationKPI01, x.From, x.To }, (key2, group) => new { Location = key2.LocationKPI01, NumberofCamps = group.Sum(k => k.numberOfIndependentShFsCertified), NumberSHFsAttended = group.Sum(k => k.numberOfShFsAttended), Month = (key2.From.Value.ToString("MMM-") + key2.To.Value.ToString("MMM yy")) }).ToList();

                if (KPI2Outputdata != null)
                {
                    foreach (var obj in KPI2Outputdata)
                    {
                        KPI2DisplayModel output = new KPI2DisplayModel();
                        output.Month = obj.Month;
                        output.NumberofTrainingCamps = Convert.ToDouble(obj.NumberofCamps);
                        output.numberOfShFsAttended = Convert.ToDouble(obj.NumberSHFsAttended);
                        locationoutput.Add(output);
                    }
                }
            }


            return locationoutput;
        }

        public object DeleteformIOdynamic(string Id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteformIOdynamic", "LivesService"));
            LoggingManager.Debug(Id.ToString());
            List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "_id",
                KeyValue = "id",
                Type = "string"
            });

           var data = _dataSetService.DeleteDynamicDataSets(Id, loggedInContext, validationMessages);

            if (data != null)
            {
                return data;
            }
            return data;
        }

        public object DeleteDatasetById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteDatasetById", "LivesService"));
            LoggingManager.Debug(id.ToString());
            List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "_id",
                KeyValue = id,
                Type = "string"
            });

            var data = _dataSetService.DeleteDatasetById(id, loggedInContext, validationMessages);

            if (data != null)
            {
                return data;
            }
            return data;
        }
    }
}
