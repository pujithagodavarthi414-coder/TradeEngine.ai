using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Expenses;
using Btrak.Models.MasterData;
using Btrak.Models.PayRoll;
using Btrak.Models.SystemManagement;
using Btrak.Models.User;
using Btrak.Models.Widgets;
using Btrak.Services.Audit;
using Btrak.Services.Chromium;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.FileUploadDownload;
using Btrak.Services.Helpers;
using BTrak.Common;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using Hangfire;
using Microsoft.Azure;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;
using static BTrak.Common.Enumerators;

namespace Btrak.Services.ExpenseService
{
    public class ExpenseService : IExpenseService
    {
        private readonly IAuditService _auditService;
        private readonly ExpenseRepository _expenseRepository;
        private readonly ExpenseValidationHelper _expenseValidationHelper;
        private readonly IChromiumService _chromiumService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly Dapper.Dal.Repositories.GoalRepository _goalRepository = new Dapper.Dal.Repositories.GoalRepository();
        private readonly Dapper.Dal.Repositories.UserRepository _userRepository = new Dapper.Dal.Repositories.UserRepository();
        private readonly MasterDataManagementRepository _masterDataManagementRepository = new MasterDataManagementRepository();
        private readonly FileStoreService _fileStoreService = new FileStoreService();
        private readonly WidgetRepository _widgetRepository = new WidgetRepository();
        private readonly IEmailService _emailService;

        public ExpenseService(IChromiumService chromiumService, IAuditService auditService, ExpenseRepository expenseRepository, ExpenseValidationHelper expenseValidationHelper, ICompanyStructureService companyStructureService, IEmailService emailService)
        {
            _auditService = auditService;
            _expenseRepository = expenseRepository;
            _expenseValidationHelper = expenseValidationHelper;
            _chromiumService = chromiumService;
            _companyStructureService = companyStructureService;
            _emailService = emailService;
        }

        public Guid? UpsertMerchant(MerchantModel merchantModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Merchant", "MerchantModel", merchantModel, "Expense Service"));

            _expenseValidationHelper.UpsertMerchantCheckValidation(merchantModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            Guid? merchantId = _expenseRepository.UpsertMerchant(merchantModel, loggedInContext, validationMessages);

            if (merchantId != Guid.Empty && merchantId != null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Merchant audit saving", "merchantId", merchantId, "Expense Service"));

                if (merchantModel.MerchantId != null)
                {
                    LoggingManager.Debug("Merchant updated Successfully with the Id :" + merchantId);
                }
                else
                {
                    LoggingManager.Debug("Merchant inserted Successfully with the Id :" + merchantId);
                }

                _auditService.SaveAudit(AppCommandConstants.UpsertMerchantCommandId, merchantModel, loggedInContext);

                return merchantId;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Merchant Failed", "Expense Service"));
            return null;
        }

        public List<MerchantModel> SearchMerchants(SearchMerchantApiInputModel searchMerchantApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Merchants", "searchMerchantApiInputModel", searchMerchantApiInputModel, "expense Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.SearchMerchantsCommandId, searchMerchantApiInputModel, loggedInContext);
            return _expenseRepository.SearchMerchants(searchMerchantApiInputModel, loggedInContext, validationMessages);

        }

        public MerchantModel GetMerchantById(Guid? merchantId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Merchant By Id", "merchantId", merchantId, "expense Service"));

            _expenseValidationHelper.GetMerchantByIdValidation(merchantId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            SearchMerchantApiInputModel searchMerchantApiInputModel = new SearchMerchantApiInputModel
            {
                MerchantId = merchantId,
            };

            _auditService.SaveAudit(AppCommandConstants.GetMerchantByIdCommandId, searchMerchantApiInputModel, loggedInContext);

            List<MerchantModel> merchants = _expenseRepository.SearchMerchants(searchMerchantApiInputModel, loggedInContext, validationMessages);

            if (merchants.Count > 0)
            {
                return merchants[0];
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundMerchantwithTheId, merchantId)
            });

            return null;
        }

        public Guid? UpsertExpenseCategory(UpsertExpenseCategoryApiInputModel upsertExpenseCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Expense Category", "UpsertExpenseCategoryApiInputModel", upsertExpenseCategoryApiInputModel, "Expense Service"));

            _expenseValidationHelper.UpsertExpenseCategoryCheckValidation(upsertExpenseCategoryApiInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            Guid? categoryId = _expenseRepository.UpsertExpenseCategory(upsertExpenseCategoryApiInputModel, loggedInContext, validationMessages);

            if (categoryId != Guid.Empty && categoryId != null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Category audit saving", "categoryId", categoryId, "Expense Service"));

                if (upsertExpenseCategoryApiInputModel.ExpenseCategoryId == categoryId)
                {
                    LoggingManager.Debug("Expense Category updated Successfully with the Id :" + categoryId);
                }
                else
                {
                    LoggingManager.Debug("Expense Category inserted Successfully with the Id :" + categoryId);
                }

                _auditService.SaveAudit(AppCommandConstants.UpsertExpenseCategoryCommandId, upsertExpenseCategoryApiInputModel, loggedInContext);

                return categoryId;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Expense Category Failed", "Expense Service"));

            return null;
        }

        public List<ExpenseCategoryModel> SearchExpenseCategories(ExpenseCategorySearchInputModel expenseCategorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Expense categories", "expenseCategorySearchInputModel", expenseCategorySearchInputModel, "expense Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.SearchExpenseCategoriesCommandId, expenseCategorySearchInputModel, loggedInContext);

            List<ExpenseCategoryModel> result = _expenseRepository.SearchExpenseCategories(expenseCategorySearchInputModel, loggedInContext, validationMessages);

            return result;
        }

        public Guid? UpsertExpenseStatus(UpsertExpenseStatusModel upsertExpenseStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Expense Status", "upsertExpenseStatusModel", upsertExpenseStatusModel, "Expense Service"));

            _expenseValidationHelper.UpsertExpenseStatusCheckValidation(upsertExpenseStatusModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            Guid? statusId = _expenseRepository.UpsertExpenseStatus(upsertExpenseStatusModel, loggedInContext, validationMessages);

            if (statusId != null && statusId != Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Status audit saving", "statusId", statusId, "Expense Service"));

                if (upsertExpenseStatusModel.Id == statusId)
                {
                    LoggingManager.Debug("Expense status updated Successfully with the Id :" + statusId);
                }
                else
                {
                    LoggingManager.Debug("Expense status inserted Successfully with the Id :" + statusId);
                }

                _auditService.SaveAudit(AppCommandConstants.UpsertExpenseStatusCommandId, upsertExpenseStatusModel, loggedInContext);

                return statusId;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Expense Status Failed", "Expense Service"));

            return null;
        }

        public ExpenseCategoryModel GetExpenseCategoryById(Guid? categoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Expense CategoryById", "categoryId", categoryId, "expense Service"));

            if (!ExpenseValidationHelper.ExpenseCategoryByIdValidation(categoryId, loggedInContext, validationMessages))
            {
                return null;
            }

            ExpenseCategorySearchInputModel searchExpenseCategoryInputModel = new ExpenseCategorySearchInputModel
            {
                ExpenseCategoryId = categoryId,
            };

            _auditService.SaveAudit(AppCommandConstants.GetExpenseCategoryByIdCommandId, searchExpenseCategoryInputModel, loggedInContext);

            List<ExpenseCategoryModel> expenseById = _expenseRepository.SearchExpenseCategories(searchExpenseCategoryInputModel, loggedInContext, validationMessages);

            if (expenseById.Count > 0)
            {
                return expenseById[0];
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundExpensesWithTheId, categoryId)
            });

            return null;
        }

        public Guid? UpsertExpenseReport(ExpenseReportInputModel expenseReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Expense Report", "expenseReportInputModel", expenseReportInputModel, "Expense Service"));

            if (!ExpenseValidationHelper.UpsertExpenseReportValidation(expenseReportInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            List<Guid?> expensesIdList = expenseReportInputModel.ExpensesList;
            string expensesXmlIds = expensesIdList != null ? Utilities.ConvertIntoListXml(expensesIdList) : null;
            Guid? expensesId = _expenseRepository.UpsertExpenseReport(expenseReportInputModel, expensesXmlIds, loggedInContext, validationMessages);

            if (expensesId != Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Report audit saving", "expenseReportInputModel", expenseReportInputModel, "Expense Service"));

                if (expenseReportInputModel.ExpenseReportId == expensesId)
                {
                    LoggingManager.Debug("ExpenseReport updated Successfully with the Id :" + expensesId);
                }
                else
                {
                    LoggingManager.Debug("ExpenseReport inserted Successfully with the Id :" + expensesId);
                }

                _auditService.SaveAudit(AppCommandConstants.UpsertExpenseReportCommandId, expenseReportInputModel, loggedInContext);
                return expensesId;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Expense Report Failed", "Expense Service"));
            return null;
        }

        public List<ExpenseStatusModel> GetAllExpenseStatuses(ExpenseStatusSearchInputModel expenseStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get All Expense Statuses", "expenseStatusSearchInputModel", expenseStatusSearchInputModel, "expense Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetAllExpenseStatusesCommandId, "Get All Expense Statuses", loggedInContext);

            return _expenseRepository.GetAllExpenseStatuses(expenseStatusSearchInputModel, loggedInContext, validationMessages);
        }

        public ExpenseStatusModel GetExpenseStatusById(Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Expense Status ById", "statusId", statusId, "expense Service"));

            if (!ExpenseValidationHelper.ExpenseStatusByIdValidation(statusId, loggedInContext, validationMessages))
            {
                return null;
            }

            ExpenseStatusSearchInputModel expenseStatusSearchInputModel = new ExpenseStatusSearchInputModel
            {
                ExpenseStatusId = statusId
            };

            _auditService.SaveAudit(AppCommandConstants.GetExpenseStatusByIdCommandId, expenseStatusSearchInputModel, loggedInContext);

            List<ExpenseStatusModel> expenseStatus = _expenseRepository.GetAllExpenseStatuses(expenseStatusSearchInputModel, loggedInContext, validationMessages);

            if (expenseStatus.Count > 0)
            {
                return expenseStatus[0];
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundExpenseStatusWithTheId, statusId)
            });

            return null;
        }

        public Guid? UpsertExpenseReportStatus(UpsertExpenseReportStatusModel upsertExpenseReportStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Expense Report Status", "upsertExpenseReportStatusModel", upsertExpenseReportStatusModel, "Expense Service"));

            if (!ExpenseValidationHelper.UpsertExpenseReportStatusValidation(upsertExpenseReportStatusModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? expenseReportStatusId = _expenseRepository.UpsertExpenseReportStatus(upsertExpenseReportStatusModel, loggedInContext, validationMessages);

            if (expenseReportStatusId != Guid.Empty && expenseReportStatusId != null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Report Status audit saving", "upsertExpenseReportStatusModel", upsertExpenseReportStatusModel, "Expense Service"));

                if (upsertExpenseReportStatusModel.ExpenseReportStatusId == expenseReportStatusId)
                {
                    LoggingManager.Debug("ExpenseReportStatus updated Successfully with the Id :" + expenseReportStatusId);
                }
                else
                {
                    LoggingManager.Debug("ExpenseReportStatus inserted Successfully with the Id :" + expenseReportStatusId);
                }

                _auditService.SaveAudit(AppCommandConstants.UpsertExpenseReportStatusCommandId, upsertExpenseReportStatusModel, loggedInContext);

                return expenseReportStatusId;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Expense Report Status Failed", "Expense Service"));
            return null;
        }

        public List<ExpenseReportStatusModel> GetExpenseReportStatuses(ExpenseReportStatusSearchInputModel expenseReportStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Expense Report Statuses", "expenseReportStatusSearchInputModel", expenseReportStatusSearchInputModel, "expense Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetExpenseReportStatusesCommandId, expenseReportStatusSearchInputModel, loggedInContext);

            return _expenseRepository.GetExpenseReportStatuses(expenseReportStatusSearchInputModel, loggedInContext, validationMessages);
        }

        public ExpenseReportStatusModel GetExpenseReportStatusById(Guid? reportStatusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Expense Report Status ById", "reportStatusId", reportStatusId, "expense Service"));

            if (!ExpenseValidationHelper.ExpenseReportStatusByIdValidation(reportStatusId, loggedInContext, validationMessages))
            {
                return null;
            }

            ExpenseReportStatusSearchInputModel expenseReportStatusSearchInputModel = new ExpenseReportStatusSearchInputModel
            {
                ExpenseReportStatusId = reportStatusId
            };

            _auditService.SaveAudit(AppCommandConstants.GetExpenseReportStatusByIdCommandId, expenseReportStatusSearchInputModel, loggedInContext);

            List<ExpenseReportStatusModel> expenseReportStatus = _expenseRepository.GetExpenseReportStatuses(expenseReportStatusSearchInputModel, loggedInContext, validationMessages);

            if (expenseReportStatus.Count > 0)
            {
                return expenseReportStatus[0];
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundExpenseStatusWithTheId, reportStatusId)
            });

            return null;
        }

        public List<SearchExpensesReportOutputModel> SearchExpenseReports(SearchExpenseReportsInputModel searchExpenseReportsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Expense Reports", "searchExpenseReportsInputModel", searchExpenseReportsInputModel, "expense Service"));
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, searchExpenseReportsInputModel, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.SearchExpenseReportsCommandId, "Search Expense Reports", loggedInContext);
            List<SearchExpensesReportOutputModel> expenseReports = _expenseRepository.SearchExpenseReports(searchExpenseReportsInputModel, loggedInContext, validationMessages).ToList();
            if (expenseReports.Count > 0)
            {
                return expenseReports;
            }
            return null;
        }

        public SearchExpensesReportOutputModel GetExpenseReportById(Guid? expenseReportId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Expense Report ById", "expenseReportId", expenseReportId, "expense Service"));

            if (!ExpenseValidationHelper.ExpenseReportByIdValidation(expenseReportId, loggedInContext, validationMessages))
            {
                return null;
            }

            SearchExpenseReportsInputModel searchExpenseReportsInputModel = new SearchExpenseReportsInputModel
            {
                ExpenseReportId = expenseReportId
            };

            _auditService.SaveAudit(AppCommandConstants.GetExpenseReportByIdCommandId, "Get Expense ReportById", loggedInContext);

            List<SearchExpensesReportOutputModel> expenseReportsById = _expenseRepository.SearchExpenseReports(searchExpenseReportsInputModel, loggedInContext, validationMessages);

            if (expenseReportsById.Count > 0)
            {
                return expenseReportsById[0];
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundExpenseReportWithTheId, expenseReportId)
            });

            return null;
        }

        public Guid? UpsertExpense(ExpenseUpsertInputModel expenseUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertExpense", "Expense Service and logged details=" + loggedInContext, validationMessages));

            var expenseId = expenseUpsertInputModel.ExpenseId;
            var host = HttpContext.Current.Request.Url.Authority;

            expenseUpsertInputModel.Description = expenseUpsertInputModel.Description?.Trim();

            if (!ExpenseValidationHelper.ValidateUpsertExpense(expenseUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (expenseUpsertInputModel.ExpenseCategories != null && expenseUpsertInputModel.ExpenseCategories.Count > 0)
            {
                expenseUpsertInputModel.ExpensesXmlModel = Utilities.ConvertIntoListXml(expenseUpsertInputModel.ExpenseCategories);
            }

            expenseUpsertInputModel.ExpenseId = _expenseRepository.UpsertExpense(expenseUpsertInputModel, loggedInContext, validationMessages);

            if (expenseUpsertInputModel.ExpenseId != null && expenseUpsertInputModel.ExpenseId != Guid.Empty && expenseUpsertInputModel.IsRecurringExpense)
            {
                CronExpressionInputModel cronExpressionInputModel = new CronExpressionInputModel();
                cronExpressionInputModel.CronExpressionId = expenseUpsertInputModel.CronExpressionId;
                cronExpressionInputModel.CronExpression = expenseUpsertInputModel.CronExpression;
                cronExpressionInputModel.CronExpressionDescription = expenseUpsertInputModel.CronExpressionDescription;
                cronExpressionInputModel.CustomWidgetId = expenseUpsertInputModel.ExpenseId;
                cronExpressionInputModel.TimeStamp = expenseUpsertInputModel.CronExpressionTimeStamp;

                UpsertCronExpressionApiReturnModel upsertCronExpressionApiReturnModel = _widgetRepository.UpsertCronExpression(cronExpressionInputModel, loggedInContext, validationMessages);

                if (upsertCronExpressionApiReturnModel != null && upsertCronExpressionApiReturnModel.JobId != null)
                {
                    cronExpressionInputModel.CronExpression = cronExpressionInputModel.CronExpression.Replace('?', '*');
                    RecurringJob.AddOrUpdate(upsertCronExpressionApiReturnModel.JobId.ToString(),
                    () => PostMethod(expenseUpsertInputModel, loggedInContext, validationMessages),
                        cronExpressionInputModel.CronExpression);
                }
            }
            else if (!expenseUpsertInputModel.IsRecurringExpense && expenseUpsertInputModel.IsArchived == true)
            {
                CronExpressionInputModel cronExpressionInputModel = new CronExpressionInputModel();
                cronExpressionInputModel.CronExpressionId = expenseUpsertInputModel.CronExpressionId;
                cronExpressionInputModel.CronExpression = expenseUpsertInputModel.CronExpression;
                cronExpressionInputModel.CronExpressionDescription = expenseUpsertInputModel.CronExpressionDescription;
                cronExpressionInputModel.CustomWidgetId = expenseUpsertInputModel.ExpenseId;
                cronExpressionInputModel.TimeStamp = expenseUpsertInputModel.CronExpressionTimeStamp;
                cronExpressionInputModel.IsArchived = true;

                _widgetRepository.UpsertCronExpression(cronExpressionInputModel, loggedInContext, validationMessages);
                RecurringJob.RemoveIfExists(expenseUpsertInputModel.JobId.ToString());
            }

            TaskWrapper.ExecuteFunctionInNewThread(async() =>
            {
                var mailHeader = expenseId != null ? "Expense updated :" + expenseUpsertInputModel.ExpenseName : "New Expense Added : " + expenseUpsertInputModel.ExpenseName;
                ExpenseApiReturnModel expenseDetails = GetExpenseById(expenseUpsertInputModel.ExpenseId, loggedInContext, validationMessages);
                var usersList = GetApprovedUserMails(loggedInContext, validationMessages);

                List<string> toMailsList = new List<string>();
                toMailsList.Add(expenseDetails.CreatedByUserMail);
                if (expenseDetails.CreatedByUserMail != expenseDetails.ClaimedByUserMail)
                {
                    toMailsList.Add(expenseDetails.ClaimedByUserMail);
                }
                UserOutputModel userDetails;

                if (expenseId != null)
                {
                    userDetails = new UserOutputModel();
                    userDetails = GetUserById(loggedInContext.LoggedInUserId, true, loggedInContext, validationMessages);
                    if (userDetails != null)
                    {
                        var isExist = toMailsList.Find(x => x == userDetails.Email);
                        if (isExist == null && userDetails != null)
                        {
                            toMailsList.Add(userDetails.Email);
                        }
                    }
                }

                if (usersList != null && usersList.Count > 0)
                {
                    foreach (var user in usersList)
                    {
                        var isUserExist = toMailsList.Find(x => x == user.Email);
                        if (isUserExist == null)
                        {
                            toMailsList.Add(user.Email);
                        }
                    }
                }

                ExpenseMailModel expenseMailDetails = new ExpenseMailModel
                {
                    TO = toMailsList.ToArray(),
                    ExpenseName = expenseDetails.ExpenseName,
                    ExpenseDate = expenseDetails.ExpenseDate,
                    ExpenseStatus = expenseDetails.ExpenseStatus,
                    ExpenseCategoriesConfigurations = expenseDetails.ExpenseCategoriesConfigurations,
                    TotalAmount = expenseDetails.TotalAmount,
                    CurrencySymbol = expenseDetails.CurrencySymbol
                };

                await SendExpenseMail(expenseMailDetails, loggedInContext, validationMessages, host, mailHeader);
            });

            LoggingManager.Info("Expense with the id " + expenseUpsertInputModel.ExpenseId + " has been updated to " + expenseUpsertInputModel);

            _auditService.SaveAudit(AppCommandConstants.UpsertExpenseCommandId, expenseUpsertInputModel, loggedInContext);

            return expenseUpsertInputModel.ExpenseId;
        }

        public void PostMethod(ExpenseUpsertInputModel expenseUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            expenseUpsertInputModel.ExpenseId = null;
            expenseUpsertInputModel.ExpenseDate = DateTime.UtcNow;

            _expenseRepository.UpsertExpense(expenseUpsertInputModel, loggedInContext, validationMessages);
        }

        public Guid? ApproveOrRejectExpense(ExpenseUpsertInputModel expenseUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ApproveOrRejectExpense", "Expense Service and logged details=" + loggedInContext, validationMessages));

            expenseUpsertInputModel.ExpenseId = _expenseRepository.ApproveOrRejectExpense(expenseUpsertInputModel, loggedInContext, validationMessages);

            var host = HttpContext.Current.Request.Url.Authority;

            TaskWrapper.ExecuteFunctionInNewThread(async () =>
            {
                var mailHeader = expenseUpsertInputModel.IsPaid == true ? "Expense Paid : " + expenseUpsertInputModel.ExpenseName : (expenseUpsertInputModel.IsApproved == true ? "Expense Approved : " + expenseUpsertInputModel.ExpenseName : "Expense Rejected : " + expenseUpsertInputModel.ExpenseName);
                ExpenseApiReturnModel expenseDetails = GetExpenseById(expenseUpsertInputModel.ExpenseId, loggedInContext, validationMessages);
                UserOutputModel userOutputModel = GetUserById(loggedInContext.LoggedInUserId, true, loggedInContext, validationMessages);
                var usersList = GetApprovedUserMails(loggedInContext, validationMessages);

                List<string> toMailsList = new List<string>();
                toMailsList.Add(expenseDetails.CreatedByUserMail);
                if (expenseDetails.CreatedByUserMail != expenseDetails.ClaimedByUserMail)
                {
                    toMailsList.Add(expenseDetails.ClaimedByUserMail);
                }

                var details = toMailsList.Find(x => x == userOutputModel.Email);

                if (details == null)
                {
                    toMailsList.Add(userOutputModel.Email);
                }

                if (usersList != null && usersList.Count > 0)
                {
                    foreach (var user in usersList)
                    {
                        var isUserExist = toMailsList.Find(x => x == user.Email);
                        if (isUserExist == null)
                        {
                            toMailsList.Add(user.Email);
                        }
                    }
                }

                ExpenseMailModel expenseMailDetails = new ExpenseMailModel
                {
                    TO = toMailsList.ToArray(),
                    ExpenseName = expenseDetails.ExpenseName,
                    ExpenseDate = expenseDetails.ExpenseDate,
                    ExpenseStatus = expenseDetails.ExpenseStatus,
                    ExpenseCategoriesConfigurations = expenseDetails.ExpenseCategoriesConfigurations,
                    TotalAmount = expenseDetails.TotalAmount,
                    CurrencySymbol = expenseDetails.CurrencySymbol
                };

                await SendExpenseMail(expenseMailDetails, loggedInContext, validationMessages, host, mailHeader);
            });

            LoggingManager.Info("Expense with the id " + expenseUpsertInputModel.ExpenseId + " has been updated to " + expenseUpsertInputModel);

            _auditService.SaveAudit(AppCommandConstants.UpsertExpenseCommandId, expenseUpsertInputModel, loggedInContext);

            return expenseUpsertInputModel.ExpenseId;
        }

        public UserOutputModel GetUserById(Guid? userId, bool? isEmployeeOverviewDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered to GetUserById." + "with userId =" + userId);

            if (!UserValidationHelpers.GetUserByIdValidation(userId, loggedInContext, validationMessages))
            {
                return null;
            }

            Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel = new Models.User.UserSearchCriteriaInputModel { UserId = userId, IsEmployeeOverviewDetails = isEmployeeOverviewDetails };

            _auditService.SaveAudit(AppCommandConstants.GetUserByIdCommandId, userSearchCriteriaInputModel, loggedInContext);

            UserOutputModel userModel = _userRepository.GetAllUsers(userSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            return userModel;
        }

        public ExpenseApiReturnModel GetExpenseById(Guid? expenseId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetExpenseById", "expenseId", expenseId, "Expense Service and logged details=" + loggedInContext, validationMessages));

            ExpenseSearchCriteriaInputModel expenseModel = new ExpenseSearchCriteriaInputModel
            {
                ExpenseId = expenseId
            };

            ExpenseSpReturnModel expenseSpReturnModel = _expenseRepository.SearchExpenses(expenseModel, loggedInContext, validationMessages).FirstOrDefault();

            _auditService.SaveAudit(AppCommandConstants.GetExpenseByIdCommandId, expenseModel, loggedInContext);

            ExpenseApiReturnModel expenseApiReturnModel = ConvertToApiReturnModel(expenseSpReturnModel);

            LoggingManager.Debug(expenseApiReturnModel?.ToString());

            return expenseApiReturnModel;
        }

        public List<ExpenseApiReturnModel> SearchExpenses(ExpenseSearchCriteriaInputModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, expenseSearchCriteriaInputModel, "Expense Service and logged details=" + loggedInContext, validationMessages));

            LoggingManager.Debug(expenseSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchExpensesCommandId, expenseSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ExpenseSpReturnModel> expenseSpReturnModels = _expenseRepository.SearchExpenses(expenseSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            List<ExpenseApiReturnModel> expenseApiReturnModels = new List<ExpenseApiReturnModel>();

            if (expenseSpReturnModels.Count > 0)
            {
                expenseApiReturnModels = expenseSpReturnModels.Select(ConvertToApiReturnModel).ToList();
            }

            //var expensesDownloadPath = SearchExpensesDownloadDetails(expenseSearchCriteriaInputModel, loggedInContext, validationMessages);

            //foreach (var expense in expenseApiReturnModels)
            //{
            //    expense.ExcelBlobPath = expensesDownloadPath;
            //}

            return expenseApiReturnModels;
        }

        public ExpensesReportSummaryOutputModel GetExpenseReportSummary(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetExpenseReportSummary", "Expense Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetExpenseReportSummaryCommandId, "GetExpenseReportSummary", loggedInContext);

            ExpensesReportSummaryOutputModel expenseReportSummary = _expenseRepository.GetExpenseReportSummary(loggedInContext, validationMessages);

            if (expenseReportSummary != null)
            {
                return expenseReportSummary;
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundExpenseReportSummaryForUser, loggedInContext.LoggedInUserId)
            });

            return null;
        }

        public List<Guid?> AddMultipleExpenses(List<ExpenseUpsertInputModel> expenseUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Add Multiple Expenses", "expenseUpsertInputModel", expenseUpsertInputModel, "expense Service"));

            if (!ExpenseValidationHelper.AddMultipleExpensesValidation(expenseUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.AddMultipleExpensesCommandId, "Add Multiple Expenses", loggedInContext);
            string expensesXmlModel = null;

            if (expenseUpsertInputModel != null && expenseUpsertInputModel.Count > 0)
            {
                expensesXmlModel = Utilities.ConvertIntoListXml(expenseUpsertInputModel);
            }

            List<Guid?> expenseIds = _expenseRepository.InsertMultipleExpenses(expensesXmlModel, loggedInContext, validationMessages);
            var host = HttpContext.Current.Request.Url.Authority;
            TaskWrapper.ExecuteFunctionInNewThread(async () =>
            {
                foreach (var expense in expenseIds)
                {
                    ExpenseApiReturnModel expenseDetails = GetExpenseById(expense, loggedInContext, validationMessages);
                    if (expenseDetails != null)
                    {
                        var usersList = GetApprovedUserMails(loggedInContext, validationMessages);

                        var mailHeader = "New Expense Added : " + expenseDetails.ExpenseName;

                        List<string> toMailsList = new List<string>();
                        toMailsList.Add(expenseDetails.CreatedByUserMail);
                        if (expenseDetails.CreatedByUserMail != expenseDetails.ClaimedByUserMail)
                        {
                            toMailsList.Add(expenseDetails.ClaimedByUserMail);
                        }

                        if (usersList != null && usersList.Count > 0)
                        {
                            foreach (var user in usersList)
                            {
                                var isUserExist = toMailsList.Find(x => x == user.Email);
                                if (isUserExist == null)
                                {
                                    toMailsList.Add(user.Email);
                                }
                            }
                        }

                        ExpenseMailModel expenseMailDetails = new ExpenseMailModel
                        {
                            TO = toMailsList.ToArray(),
                            ExpenseName = expenseDetails.ExpenseName,
                            ExpenseDate = expenseDetails.ExpenseDate,
                            ExpenseStatus = expenseDetails.ExpenseStatus,
                            ExpenseCategoriesConfigurations = expenseDetails.ExpenseCategoriesConfigurations,
                            TotalAmount = expenseDetails.TotalAmount,
                            CurrencySymbol = expenseDetails.CurrencySymbol
                        };

                        await SendExpenseMail(expenseMailDetails, loggedInContext, validationMessages, host, mailHeader);
                    }
                }
            });

            return expenseIds;
        }

        private static ExpenseApiReturnModel ConvertToApiReturnModel(ExpenseSpReturnModel expenseSpReturnModel)
        {
            expenseSpReturnModel.ExpenseCategoriesConfigurations = Utilities.GetObjectFromXml<ExpenseCategoryConfigurationModel>(expenseSpReturnModel.ExpenseCategorieConfigurationsXml, "ExpenseCategoryConfigurationModel");

            ExpenseApiReturnModel expenseApiReturnModel = new ExpenseApiReturnModel
            {
                ExpenseId = expenseSpReturnModel.ExpenseId,
                ExpenseName = expenseSpReturnModel.ExpenseName,
                ClaimedByUserId = expenseSpReturnModel.ClaimedByUserId,
                ExpenseStatusId = expenseSpReturnModel.ExpenseStatusId,
                ClaimReimbursement = expenseSpReturnModel.ClaimReimbursement,
                ExpenseDate = expenseSpReturnModel.ExpenseDate,
                CurrencyId = expenseSpReturnModel.CurrencyId,
                IsApproved = expenseSpReturnModel.IsApproved,
                ClaimedByUserName = expenseSpReturnModel.ClaimedByUserName,
                CreatedByUserName = expenseSpReturnModel.CreatedByUserName,
                CreatedByUserId = expenseSpReturnModel.CreatedByUserId,
                CreatedDateTime = expenseSpReturnModel.CreatedDateTime,
                CreatedOn = expenseSpReturnModel.CreatedDateTime.ToString("dd-MM-yyyy"),
                ExpenseDateOn = expenseSpReturnModel.ExpenseDate?.ToString("dd-MM-yyyy"),
                TotalCount = expenseSpReturnModel.TotalCount,
                TimeStamp = expenseSpReturnModel.TimeStamp,
                ExpenseStatus = expenseSpReturnModel.ExpenseStatus,
                CurrencyName = expenseSpReturnModel.CurrencyName,
                CurrencySymbol = expenseSpReturnModel.CurrencySymbol,
                Receipts = expenseSpReturnModel.Receipts,
                ExpenseCategoriesConfigurations = expenseSpReturnModel.ExpenseCategoriesConfigurations,
                TotalAmount = expenseSpReturnModel.TotalAmount,
                ExpenseCategoryNames = expenseSpReturnModel.ExpenseCategoryNames,
                CronExpression = expenseSpReturnModel.CronExpression,
                CronExpressionId = expenseSpReturnModel.CronExpressionId,
                JobId = expenseSpReturnModel.JobId,
                CronExpressionTimestamp = expenseSpReturnModel.CronExpressionTimestamp,
                BranchId = expenseSpReturnModel.BranchId,
                BranchName = expenseSpReturnModel.BranchName,
                PaidStatusSetByUserId = expenseSpReturnModel.PaidStatusSetByUserId,
                PaidStatusSetByUserName = expenseSpReturnModel.PaidStatusSetByUserName,
                MerchantName = expenseSpReturnModel.MerchantName,
                IdentificationNumber = expenseSpReturnModel.IdentificationNumber,
                ClaimedByUserMail = expenseSpReturnModel.ClaimedByUserMail,
                CreatedByUserMail = expenseSpReturnModel.CreatedByUserMail
            };

            return expenseApiReturnModel;
        }

        public List<ExpenseHistoryModel> SearchExpenseHistory(ExpenseHistoryModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, expenseSearchCriteriaInputModel, "Expense Service and logged details=" + loggedInContext, validationMessages));

            _auditService.SaveAudit(AppCommandConstants.SearchExpensesCommandId, expenseSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ExpenseHistoryModel> expenseHistoryReturnModels = _expenseRepository.SearchExpenseHistory(expenseSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return expenseHistoryReturnModels;
        }

        public async Task<string> SendExpenseMail(ExpenseMailModel expenseMailModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string siteAddress, string mailHeader)
        {
            string expensePdfView = "<div class=\"invoice-container\"><div><div class=\"fxLayout-row\"><div class=\"fxFlex50-column-start mb-1\">";

            expensePdfView += "<div class=\"fxFlex100 mt-02 invoice-page invoice-amount-price word-break\">" + expenseMailModel.ExpenseName + "</div></div>";

            expensePdfView += "<div class=\"fxFlex50-column-end\"><div class=\"fxFlex100-end mt-02\"><span class=\"invoice-amount-price\" style=\"text-align: right;\">" + expenseMailModel.CurrencySymbol + expenseMailModel.TotalAmount?.ToString("n2") + "</span></div>";

            expensePdfView += "<div class=\"fxFlex100-end mt-02 mb-1\"><span class=\"mr-05\"><b>Expense date: </b></span>" + String.Format("{0:ddd, MMM d, yyyy}", expenseMailModel.ExpenseDate) + "</div></div></div>";

            expensePdfView += "<div class=\"fxLayout-row\"><div class=\"fxFlex50-column-start mb-1\"><div class=\"fxFlex100 mt-02 invoice-page word-break\"><span class=\"mr-05\"><b>Merchant: </b></span>" + expenseMailModel.MerchantName + "</div></div>";

            expensePdfView += "<div class=\"fxFlex50-column-end\"><div class=\"fxFlex100-end mt-02 mb-1\"><span class=\"mr-05\"><b>Status: </b>";

            if (expenseMailModel.ExpenseStatus == "Approved")
            {
                expensePdfView += "</span><span class=\"approved-background-color\">" + expenseMailModel.ExpenseStatus + "</span></div></div></div></div></div>";
            }
            else if (expenseMailModel.ExpenseStatus == "Rejected")
            {
                expensePdfView += "</span><span class=\"rejected-background-color\">" + expenseMailModel.ExpenseStatus + "</span></div></div></div></div></div>";
            }
            else
            {
                expensePdfView += "</span><span class=\"pending-background-color\">" + expenseMailModel.ExpenseStatus + "</span></div></div></div></div></div>";
            }

            expensePdfView += "<div class=\"invoice-container\"> <div class=\"table-responsive overflow-visible\">" +
                "<table class=\"table mb-0\"><thead><tr><th>Expense category name</th><th>Merchant name</th><th>Expense category</th><th>Description</th><th>Amount</th></tr></thead><tbody>";

            foreach (var item in expenseMailModel.ExpenseCategoriesConfigurations)
            {
                expensePdfView += "<tr><td>" + item.ExpenseCategoryName;

                expensePdfView += "</td><td>" + item.MerchantName;

                expensePdfView += "</td><td>" + item.CategoryName;

                expensePdfView += "</td><td>" + item.Description + "</td><td><label>" + expenseMailModel.CurrencySymbol + "" + item.Amount?.ToString("n2") + "</label></td></tr>";
            }

            expensePdfView += "</tbody></table></div></div>";

            expensePdfView += "<div class=\"fxLayout-row mt-1-05 invoice-container\">" +
            "<div class=\"fxFlex48\"></div><div class=\"fxFlex div-page-break\">" +
                "<hr class=\"ml-1\"><div class=\"fxLayout-row mt-05 ml-1 mb-1\"><div class=\"fxFlex49-column\"><span><b>Total Amount:</b></span></div>" +
                    "<div class=\"fxFlex49-column\"><span class=\"fxLayout-end\"><b>" + expenseMailModel.CurrencySymbol + expenseMailModel.TotalAmount?.ToString("n2") + "</b></span></div></div></div></div>";

            var html = _goalRepository.GetHtmlTemplateByName("ExpensePDFTemplate", loggedInContext.CompanyGuid).Replace("##ExpensePdfView##", expensePdfView);

            var pdfOutput = await _chromiumService.GeneratePdf(html, null, expenseMailModel.ExpenseName);

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

            var directory = SetupCompanyFileContainer(companyModel, 7, loggedInContext.LoggedInUserId, storageAccountName);

            var fileName = expenseMailModel.ExpenseName;

            LoggingManager.Debug("UploadCourseFile input fileName:" + fileName);

            fileName = fileName.Replace(" ", "_");

            var fileExtension = ".pdf";

            var convertedFileName = fileName + "-" + Guid.NewGuid() + fileExtension;

            CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);

            blockBlob.Properties.CacheControl = "public, max-age=2592000";

            blockBlob.Properties.ContentType = "application/pdf";

            Byte[] bytes = pdfOutput.ByteStream;

            blockBlob.UploadFromByteArray(bytes, 0, bytes.Length);

            var fileurl = blockBlob.Uri.AbsoluteUri;

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, siteAddress);

            Stream stream = new MemoryStream(pdfOutput.ByteStream);

            List<Stream> fileStream = new List<Stream>();

            fileStream.Add(stream);

            var pdfHtml = _goalRepository.GetHtmlTemplateByName("ExpenseMailTemplate", loggedInContext.CompanyGuid).Replace("##PdfUrl##", fileurl).Replace("##CurrencySymbol##", expenseMailModel.CurrencySymbol).
                Replace("##TotalAmount##", expenseMailModel.TotalAmount?.ToString("n2")).Replace("##ExpenseStatus##", mailHeader);

            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpServer = smtpDetails?.SmtpServer,
                SmtpServerPort = smtpDetails?.SmtpServerPort,
                SmtpMail = smtpDetails?.SmtpMail,
                SmtpPassword = smtpDetails?.SmtpPassword,
                ToAddresses = expenseMailModel.TO,
                HtmlContent = pdfHtml,
                Subject = "Snovasys Business Suite:" + mailHeader,
                CCMails = expenseMailModel.CC,
                BCCMails = expenseMailModel.BCC,
                MailAttachments = fileStream,
                IsPdf = true
            };
            _emailService.SendMail(loggedInContext, emailModel);
            return fileurl;
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

        public string DownloadPayRollRunTemplate(List<ExpenseExcelModel> expenses, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (expenses.Any())
            {

                var path = HostingEnvironment.MapPath(@"~\Resources\ExcelTemplates\PaymentTemplate.xlsx");
                var path1 = HostingEnvironment.MapPath(@"~\Resources\ExcelTemplates");
                var guid = Guid.NewGuid();
                if (path1 != null)
                {
                    string blobUrl;
                    var destinationPath = Path.Combine(path1, guid.ToString());
                    string docName = Path.Combine(destinationPath, "PaymentTemplate.xlsx");
                    if (!Directory.Exists(destinationPath))
                    {
                        Directory.CreateDirectory(destinationPath);

                        if (path != null) System.IO.File.Copy(path, docName, true);
                        LoggingManager.Info("Created a directory to save temp file");
                    }

                    using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                    {
                        WorksheetPart worksheetPartFirst = GetWorksheetPartByName(spreadSheet, "Converter", "Converter");

                        SheetData sheetData = worksheetPartFirst.Worksheet.GetFirstChild<SheetData>();

                        uint rowIndex = 5;

                        Row row1 = sheetData.Elements<Row>().Where(r => r.RowIndex == 1).First();
                        Row row2 = sheetData.Elements<Row>().Where(r => r.RowIndex == 2).First();
                        row1.Elements<Cell>().Where(x => x.CellReference == "E" + 1).First().CellValue = new CellValue(expenses.Where(x => x.DebitAccountNumber != null).FirstOrDefault()?.DebitAccountNumber);
                        row1.Elements<Cell>().Where(x => x.CellReference == "G" + 1).First().CellValue = new CellValue(expenses.FirstOrDefault()?.FileReference);
                        row1.Elements<Cell>().Where(x => x.CellReference == "E" + 1).First().DataType = new EnumValue<CellValues>(CellValues.Number);
                        row1.Elements<Cell>().Where(x => x.CellReference == "G" + 1).First().DataType = new EnumValue<CellValues>(CellValues.String);
                        foreach (var expense in expenses.ToList())
                        {
                            Row row;
                            if (sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).Count() != 0)
                            {
                                row = sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).First();
                            }
                            else
                            {
                                row = new Row() { RowIndex = rowIndex };
                                sheetData.Append(row);
                            }

                            row.Elements<Cell>().Where(x => x.CellReference == "A" + rowIndex).First().CellValue = new CellValue(expense.TransactionType);
                            row.Elements<Cell>().Where(x => x.CellReference == "B" + rowIndex).First().CellValue = new CellValue(expense.DebitAccountNumber);
                            row.Elements<Cell>().Where(x => x.CellReference == "C" + rowIndex).First().CellValue = new CellValue(expense.TransactionType == "WIB" ? null : expense.UserIFSCCode);
                            row.Elements<Cell>().Where(x => x.CellReference == "D" + rowIndex).First().CellValue = new CellValue(expense.BeneficiaryAccountNumber);
                            row.Elements<Cell>().Where(x => x.CellReference == "E" + rowIndex).First().CellValue = new CellValue(expense.UserName);
                            row.Elements<Cell>().Where(x => x.CellReference == "F" + rowIndex).First().CellValue = new CellValue(expense.TotalAmount.ToString());
                            row.Elements<Cell>().Where(x => x.CellReference == "F" + rowIndex).First().DataType = new EnumValue<CellValues>(CellValues.Number);
                            row.Elements<Cell>().Where(x => x.CellReference == "G" + rowIndex).First().CellValue = new CellValue(expense.ExpenseName + "-" + expense.IdentificationNumber);
                            row.Elements<Cell>().Where(x => x.CellReference == "H" + rowIndex).First().CellValue = new CellValue(expense.ExpenseName + "-" + expense.IdentificationNumber);
                            //row.Elements<Cell>().Where(x => x.CellReference == "I" + rowIndex).First().CellFormula.Reference = "SUM(A1:A3)";
                            //row.Elements<Cell>().Where(x => x.CellReference == "J" + rowIndex).First().CellFormula.Reference = "=IF(AND(ISBLANK(A" + rowIndex + "),ISBLANK(B" + rowIndex + "),ISBLANK(G" + rowIndex + "),ISBLANK(C" + rowIndex + "),ISBLANK(D" + rowIndex + "),ISBLANK(E" + rowIndex + "),ISBLANK(F" + rowIndex + ")),'',IF(AND(OR(A" + rowIndex + "!='WIB',A" + rowIndex + "!='NFT',A" + rowIndex + "!='RTG',A" + rowIndex + "!='IFC'),LEN(B" + rowIndex + "!)=12,ISNUMBER(VALUE(B" + rowIndex + "!)),IF(A" + rowIndex + "!='WIB',ISBLANK(C" + rowIndex + "!),AND(LEN(C" + rowIndex + "!)=11,MID(C" + rowIndex + "!,5,1)='0')),IF(A" + rowIndex + "!='WIB',AND(LEN(D" + rowIndex + "!)=12,ISNUMBER(VALUE(D" + rowIndex + "!))),LEN(D" + rowIndex + "!)<35),IF(ISNUMBER(F" + rowIndex + "!),LEN(ROUND(F" + rowIndex + "!,2))<16),LEN(G" + rowIndex + "!)<31,IF(A" + rowIndex + "!='WIB',OR(COUNTA(A" + rowIndex + ":D" + rowIndex + "!)=6,COUNTA(A" + rowIndex + ":D" + rowIndex + "!)=7),COUNTA(A" + rowIndex + ":D" + rowIndex + "!)=7)),IF(A" + rowIndex + "!='WIB','APW','APO')&'|'&A" + rowIndex + "!&'|'&ROUND(F" + rowIndex + "!,2)&'|INR|'&B" + rowIndex + "!&'|0011|'&IF(A" + rowIndex + "!='WIB',''ICIC0000011'',C" + rowIndex + "!)&'|'&D" + rowIndex + "!&'|0011|'&E" + rowIndex + "!&'|'&G" + rowIndex + "!&'|'&H" + rowIndex + "!&'^','Please correct data'))";
                            rowIndex++;
                        }

                        //save document on the end
                        worksheetPartFirst.Worksheet.Save();
                        spreadSheet.WorkbookPart.Workbook.Save();

                        spreadSheet.Close();
                        blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                        {
                            MemoryStream = System.IO.File.ReadAllBytes(docName),
                            FileName = "ExpensesTemplate" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                            ContentType = "application/xlsx",
                            LoggedInUserId = loggedInContext.LoggedInUserId
                        });
                    }

                    if (Directory.Exists(destinationPath))
                    {
                        System.IO.File.Delete(docName);
                        Directory.Delete(destinationPath);

                        LoggingManager.Info("Deleting the temp folder");
                    }
                    return blobUrl;
                }
            }
            return null;
        }

        private WorksheetPart GetWorksheetPartByName(SpreadsheetDocument document, string sheetName, string newName)
        {
            IEnumerable<Sheet> sheets =
                document.WorkbookPart.Workbook.GetFirstChild<Sheets>().
                    Elements<Sheet>().Where(s => s.Name == sheetName).ToList();

            if (!sheets.Any())
            {
                return null;
            }

            string relationshipId = sheets.First().Id.Value;
            if (!String.IsNullOrEmpty(newName)) sheets.First().Name = newName;
            WorksheetPart worksheetPart = (WorksheetPart)document.WorkbookPart.GetPartById(relationshipId);

            return worksheetPart;
        }

        public string SearchExpensesDownloadDetails(ExpenseSearchCriteriaInputModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, expenseSearchCriteriaInputModel, "Expense Service and logged details=" + loggedInContext, validationMessages));

            _auditService.SaveAudit(AppCommandConstants.SearchExpensesCommandId, expenseSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ExpenseExcelModel> expenseSpReturnModels = _expenseRepository.SearchExpensesDownloadDetails(expenseSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            var expensesDownloadPath = DownloadPayRollRunTemplate(expenseSpReturnModels, loggedInContext, validationMessages);

            return expensesDownloadPath;
        }

        public List<ExpenseStatusSearchCriteriaInputModel> SearchExpenseStatuses(ExpenseStatusSearchCriteriaInputModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, expenseSearchCriteriaInputModel, "Expense Service and logged details=" + loggedInContext, validationMessages));

            LoggingManager.Debug(expenseSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchExpensesCommandId, expenseSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ExpenseStatusSearchCriteriaInputModel> expenseSpReturnModels = _expenseRepository.SearchExpenseStatuses(expenseSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return expenseSpReturnModels;
        }

        public Guid? ApprovePendingExpenses(ExpenseStatusSearchCriteriaInputModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, expenseSearchCriteriaInputModel, "Expense Service and logged details=" + loggedInContext, validationMessages));

            LoggingManager.Debug(expenseSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchExpensesCommandId, expenseSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? expenseSpReturnModels = _expenseRepository.ApprovePendingExpenses(expenseSearchCriteriaInputModel, loggedInContext, validationMessages);

            return expenseSpReturnModels;
        }

        public List<ApprovedUserModel> GetApprovedUserMails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, null, "Expense Service and logged details=" + loggedInContext, validationMessages));
            
            List<ApprovedUserModel> mailsList = _expenseRepository.GetApprovedUserMails(loggedInContext, validationMessages);

            return mailsList;
        }
    }
}