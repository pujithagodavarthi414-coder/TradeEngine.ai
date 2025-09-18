using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.GenericForm;
using Btrak.Models.MasterData;
using Btrak.Models.Performance;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.MasterDataValidationHelper;
using Btrak.Services.User;
using BTrak.Common;
using JsonDiffPatchDotNet;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Btrak.Services.MasterData
{
    public class GenericFormMasterDataService : IGenericFormMasterDataService
    {
        private readonly GenericFormMasterDataRepository _genericFormMasterDataRepository;
        private readonly IAuditService _auditService;
        private readonly IUserService _userService;
        private readonly GenericFormRepository _genericFormRepository;

        public GenericFormMasterDataService(GenericFormMasterDataRepository genericFormMasterDataRepository, IUserService userService, IAuditService auditService, GenericFormRepository genericFormRepository)
        {
            _genericFormMasterDataRepository = genericFormMasterDataRepository;
            _auditService = auditService;
            _userService = userService;
            _genericFormRepository = genericFormRepository;
        }

        public Guid? UpsertGenericFormType(GenericFormTypeUpsertModel genericFormTypeUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGenericFormType", "genericFormTypeUpsertModel", genericFormTypeUpsertModel, "GenericFormMasterDataService"));

            if (!GenericFormMasterDataValidationHelper.UpsertGenericFormTypeValidation(genericFormTypeUpsertModel, loggedInContext, validationMessages))
            {
                return null;
            }

            genericFormTypeUpsertModel.FormTypeId = _genericFormMasterDataRepository.UpsertGenericFormType(genericFormTypeUpsertModel, loggedInContext, validationMessages);

            LoggingManager.Debug("FormType with the id " + genericFormTypeUpsertModel.FormTypeId);

            _auditService.SaveAudit(AppCommandConstants.UpsertGenericFormTypeCommandId, genericFormTypeUpsertModel, loggedInContext);

            return genericFormTypeUpsertModel.FormTypeId;
        }

        public List<GetGenericFormTypesOutputModel> GetGenericFormTypes(GetGenericFormTypesSearchCriteriaInputModel getFormTypesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Generic Form Types", "genericFormSearchCriteriaInputModel", getFormTypesSearchCriteriaInputModel, "Generic Form Master Data Service"));
            _auditService.SaveAudit(AppCommandConstants.GetGenericFormTypesCommandId, getFormTypesSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                getFormTypesSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Generic Form Types list ");
            List<GetGenericFormTypesOutputModel> genericFormList = _genericFormMasterDataRepository.GetGenericFormType(getFormTypesSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return genericFormList;
        }

        public List<GetGenericFormTypesOutputModel> GetGenericFormTypesAnonymous(GetGenericFormTypesSearchCriteriaInputModel getFormTypesSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Generic Form Types", "genericFormSearchCriteriaInputModel", getFormTypesSearchCriteriaInputModel, "Generic Form Master Data Service"));

            LoggingManager.Info("Getting Generic Form Types list ");
            List<GetGenericFormTypesOutputModel> genericFormList = _genericFormMasterDataRepository.GetGenericFormTypesAnonymous(getFormTypesSearchCriteriaInputModel, validationMessages).ToList();
            return genericFormList;
        }

        public Guid? UpsertCustomFormSubmission(CustomFormSubmissionUpsertModel customFormSubmissionUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCustomFormSubmission", "customFormSubmissionUpsertModel", customFormSubmissionUpsertModel, "GenericFormMasterDataService"));

            string originalJson = string.Empty;
            List<HistoryOutputModel> historyList = new List<HistoryOutputModel>();
            GetCustomFormSubmissionOutputModel oldForm = null;
            string historyXml;

            if (customFormSubmissionUpsertModel.FormSubmissionId != null)
            {
                CustomFormSubmissionSearchCriteriaInputModel customFormSubmissionSearch = new CustomFormSubmissionSearchCriteriaInputModel { FormSubmissionId = customFormSubmissionUpsertModel.FormSubmissionId, AssignedByYou = null };

                List<GetCustomFormSubmissionOutputModel> customFormsList = _genericFormMasterDataRepository.GetCustomFormSubmissions(customFormSubmissionSearch, loggedInContext, validationMessages).ToList();
                oldForm = customFormsList.FirstOrDefault();
                originalJson = oldForm.FormData;
            }

            customFormSubmissionUpsertModel.FormSubmissionId = _genericFormMasterDataRepository.UpsertCustomFormSubmission(customFormSubmissionUpsertModel, loggedInContext, validationMessages);


            if (oldForm != null && oldForm.Status != customFormSubmissionUpsertModel.Status)
            {
                HistoryOutputModel historyRecord = new HistoryOutputModel
                {
                    Field = "status",
                    OldValue = oldForm.Status,
                    NewValue = customFormSubmissionUpsertModel.Status
                };
                historyList.Add(historyRecord);
                historyXml = Utilities.ConvertIntoListXml(historyList);

                TaskWrapper.ExecuteFunctionInNewThread(() => _genericFormRepository.InsertFormHistory(historyXml, customFormSubmissionUpsertModel.FormSubmissionId, loggedInContext, validationMessages));

                historyList = new List<HistoryOutputModel>();
            }

            if (oldForm != null && oldForm.AssignedToUserId != customFormSubmissionUpsertModel.AssignedToUserId)
            {
                var oldUser = _userService.GetUserById(oldForm.AssignedToUserId, true, loggedInContext, validationMessages);
                var newUser = _userService.GetUserById(customFormSubmissionUpsertModel.AssignedToUserId, true, loggedInContext, validationMessages);

                HistoryOutputModel historyRecord = new HistoryOutputModel
                {
                    Field = "assignee",
                    OldValue = oldUser.FullName,
                    NewValue = newUser.FullName
                };
                historyList.Add(historyRecord);

                historyXml = Utilities.ConvertIntoListXml(historyList);

                TaskWrapper.ExecuteFunctionInNewThread(() => _genericFormRepository.InsertFormHistory(historyXml, customFormSubmissionUpsertModel.FormSubmissionId, loggedInContext, validationMessages));

                historyList = new List<HistoryOutputModel>();
            }

            if (originalJson != null && !string.IsNullOrEmpty(originalJson))
            {
                var jdp = new JsonDiffPatch();
                JToken diffJsonResult = jdp.Diff(JObject.Parse(originalJson), JObject.Parse(customFormSubmissionUpsertModel.FormData));

                if (diffJsonResult != null)
                {
                    foreach (var record in diffJsonResult.Children())
                    {
                        HistoryOutputModel historyRecord = new HistoryOutputModel
                        {
                            Field = record.Path,
                            OldValue = record.First.First.ToString(),
                            NewValue = record.First.Last.ToString()
                        };
                        historyList.Add(historyRecord);
                    }

                    historyXml = Utilities.ConvertIntoListXml(historyList);

                    TaskWrapper.ExecuteFunctionInNewThread(() => _genericFormRepository.InsertFormHistory(historyXml, customFormSubmissionUpsertModel.FormSubmissionId, loggedInContext, validationMessages));
                }
            }
            else
            {
                var jdp = new JsonDiffPatch();
                JToken diffJsonResult = jdp.Diff(JObject.Parse("{}"), JObject.Parse(customFormSubmissionUpsertModel.FormData));

                if (diffJsonResult != null)
                {
                    foreach (var record in diffJsonResult.Children())
                    {
                        HistoryOutputModel historyRecord = new HistoryOutputModel
                        {
                            Field = record.Path,
                            OldValue = string.Empty,
                            NewValue = record.First.Last.ToString()
                        };
                        historyList.Add(historyRecord);
                    }

                    historyXml = Utilities.ConvertIntoListXml(historyList);

                    TaskWrapper.ExecuteFunctionInNewThread(() => _genericFormRepository.InsertFormHistory(historyXml, customFormSubmissionUpsertModel.FormSubmissionId, loggedInContext, validationMessages));
                }
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertGenericFormTypeCommandId, customFormSubmissionUpsertModel, loggedInContext);

            return customFormSubmissionUpsertModel.FormSubmissionId;
        }

        public List<GetCustomFormSubmissionOutputModel> GetCustomFormSubmissions(CustomFormSubmissionSearchCriteriaInputModel customFormSubmissionSearch, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Custom Form Submissions", "customFormSubmissionSearch", customFormSubmissionSearch, "Generic Form Master Data Service"));
            _auditService.SaveAudit(AppCommandConstants.GetGenericFormTypesCommandId, customFormSubmissionSearch, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, customFormSubmissionSearch, validationMessages))
            {
                return null;
            }

            List<GetCustomFormSubmissionOutputModel> customFormsList = _genericFormMasterDataRepository.GetCustomFormSubmissions(customFormSubmissionSearch, loggedInContext, validationMessages).ToList();
            return customFormsList;
        }

        public Guid? UpsertInductionConfiguration(InductionModel inductionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertInductionConfiguration", "inductionModel", inductionModel, "Generic Form Master Data Service"));
            _auditService.SaveAudit(AppCommandConstants.GetGenericFormTypesCommandId, inductionModel, loggedInContext);

            return _genericFormMasterDataRepository.UpsertInductionConfiguration(inductionModel, loggedInContext, validationMessages);
        }

        public List<InductionModel> GetInductionConfigurations(InductionModel inductionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetInductionConfigurations", "inductionModel", inductionModel, "Generic Form Master Data Service"));
            _auditService.SaveAudit(AppCommandConstants.GetGenericFormTypesCommandId, inductionModel, loggedInContext);

            return _genericFormMasterDataRepository.GetInductionConfigurations(inductionModel, loggedInContext, validationMessages);
        }

        public List<EmployeeInductionModel> GetEmployeeInductions(EmployeeInductionModel inductionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeInductions", "inductionModel", inductionModel, "Generic Form Master Data Service"));
            _auditService.SaveAudit(AppCommandConstants.GetGenericFormTypesCommandId, inductionModel, loggedInContext);

            return _genericFormMasterDataRepository.GetEmployeeInductions(inductionModel, loggedInContext, validationMessages);
        }

        public Guid? UpsertExitConfiguration(ExitModel exitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertExitConfiguration", "inductionModel", exitModel, "Generic Form Master Data Service"));
            _auditService.SaveAudit(AppCommandConstants.GetGenericFormTypesCommandId, exitModel, loggedInContext);

            return _genericFormMasterDataRepository.UpsertExitConfiguration(exitModel, loggedInContext, validationMessages);
        }

        public List<ExitModel> GetExitConfigurations(ExitModel exitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetExitConfigurations", "inductionModel", exitModel, "Generic Form Master Data Service"));
            _auditService.SaveAudit(AppCommandConstants.GetGenericFormTypesCommandId, exitModel, loggedInContext);

            return _genericFormMasterDataRepository.GetExitConfigurations(exitModel, loggedInContext, validationMessages);
        }

        public List<EmployeeExitModel> GetEmployeeExits(EmployeeExitModel exitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetExitInductions", "inductionModel", exitModel, "Generic Form Master Data Service"));
            _auditService.SaveAudit(AppCommandConstants.GetGenericFormTypesCommandId, exitModel, loggedInContext);

            return _genericFormMasterDataRepository.GetEmployeeExits(exitModel, loggedInContext, validationMessages);
        }
    }
}
