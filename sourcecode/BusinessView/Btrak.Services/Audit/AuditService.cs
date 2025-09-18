using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Dapper.Dal.SpModels;
using Btrak.Models.Audit;
using Btrak.Services.Helpers;
using Newtonsoft.Json;
using Cronos;
using Btrak.Models.MasterData;
using Btrak.Dapper.Dal.Partial;
using System.Collections.Concurrent;

namespace Btrak.Services.Audit
{
    public class AuditService : IAuditService
    {
        private readonly AuditRepository _auditRepository = new AuditRepository();
        private readonly MasterDataManagementRepository _masterManagementRepository = new MasterDataManagementRepository();
        public static ConcurrentDictionary<string, string> _companySettingsDictionary = new ConcurrentDictionary<string, string>();

        public void SaveAudit<T>(Guid featureId, T auditObject, LoggedInContext loggedInContext)
        {

            CompanySettingsSearchInputModel companySettingsSearchInputModel = new CompanySettingsSearchInputModel
            {
                Key = "IsAuditEnable",
                IsArchived = false
            };

            string isAuditEnable = string.Empty;

            if (_companySettingsDictionary.ContainsKey("IsAuditEnable"))
            {
                isAuditEnable = _companySettingsDictionary["IsAuditEnable"];
            }
            else
            {
                isAuditEnable = _masterManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, null).Select(x => x.Value).FirstOrDefault();
                
                _companySettingsDictionary.TryAdd("IsAuditEnable", isAuditEnable);
            }
            

            if (isAuditEnable == "1")
            {
                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    try
                    {
                        var auditModel = new AuditModel
                        {
                            AuditObject = auditObject,
                            FeatureId = featureId
                        };

                        LoggingManager.Info(() => "Audit addition has been requested with content " + auditObject + ", with the feature id " +
                                                  featureId + " under the context " + loggedInContext);

                        _auditRepository.SaveAudit(auditModel, loggedInContext);
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveAudit", " AuditService", exception.Message), exception);

                    }
                });
            }
        }

        public List<AuditHistoryModel> SearchAuditHistory(AuditSearchCriteriaInputModel auditSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAuditHistory", "Audit Service"));

            if (loggedInContext.LoggedInUserId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search Audit History validating LoggedInUserId", "Audit Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NullValue
                });
                return null;
            }

            if (auditSearchCriteriaInputModel.PageNumber == 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search Audit History validating PageNumber", "Audit Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PageNumberRequired
                });
            }

            if (auditSearchCriteriaInputModel.PageSize == 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search Audit History validating PageSize", "Audit Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PageSizeRequired
                });
            }

            if (auditSearchCriteriaInputModel.PageSize > AppConstants.InputWithMaxSize1000)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthPageSize
                });
            }

            if (validationMessages.Any()) return null;

            return _auditRepository.SearchAuditHistory(auditSearchCriteriaInputModel, loggedInContext, validationMessages);
        }

        [Obsolete]
        public IList<AuditJsonModel> GetHistoryDetails(Guid userId, DateTime? dateFrom, DateTime? dateTo, Guid featureId)
        {
            IList<AuditJsonModel> history = new List<AuditJsonModel>();

            IList<TimesheetAuditModel> historyDetails = _auditRepository.GetAudit(userId, featureId, Guid.Empty, dateFrom, dateTo);
            foreach (var historyDetail in historyDetails)
            {
                AuditJsonModel detail = new AuditJsonModel
                {
                    UserId = historyDetail.UserId,
                    FeatureId = historyDetail.FeatureId,
                    UserName = historyDetail.UserName,
                    Description = "<b>" + historyDetail.UserName + "</b>" + historyDetail.AuditDescription,
                };
                history.Add(detail);
            }
            return history;
        }

        [Obsolete]
        public IList<AuditJsonModel> GetUserStoryAudit(AuditModelFields fields)
        {
            return _auditRepository.GetAudit(fields.UserId, fields.FeatureId, fields.UserStoryId, fields.DateFrom, fields.DateTo).OrderBy(x => x.CreatedDateTime).Select(x => new AuditJsonModel
            {
                UserId = x.UserId,
                UserName = x.UserName,
                UserStoryId = x.UserStoryId,
                CreatedDate = x.CreatedDateTime,
                Description = x.AuditDescription
            }).ToList();
        }

        public IList<Models.Audit.Audit> GetAuditByBranch(AuditTimelineInputModel auditTimelineInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditByBranch", "Audit Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditByBranch", "Audit Service"));

            if(auditTimelineInputModel != null && auditTimelineInputModel.BranchIds != null)
            {
                auditTimelineInputModel.BranchIdJSON = JsonConvert.SerializeObject(auditTimelineInputModel.BranchIds);
            }
            else
            {
                auditTimelineInputModel.BranchIdJSON = null;
            }
            List<Models.Audit.Audit> auditList = _auditRepository.GetAuditByBranch(auditTimelineInputModel, loggedInContext, validationMessages);

            return auditList;
        }

        public IList<AuditConductTimelineOutputModel> GetAuditConductTimeline(AuditTimelineInputModel auditTimelineInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditConductTimeline", "Audit Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            auditTimelineInputModel.BranchIdJSON = JsonConvert.SerializeObject(auditTimelineInputModel.BranchIds);
            auditTimelineInputModel.AuditIdJSON = JsonConvert.SerializeObject(auditTimelineInputModel.AuditIds);
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditConductTimeline", "Audit Service"));

            if (auditTimelineInputModel != null && auditTimelineInputModel.BusinessUnitIds != null && auditTimelineInputModel.BusinessUnitIds.Count > 0)
            {
                auditTimelineInputModel.BusinessUnitIdsList = string.Join(",", auditTimelineInputModel.BusinessUnitIds);
            }

            List<AuditConductTimelineOutputModel> auditList = _auditRepository.GetAuditConductTimeline(auditTimelineInputModel, loggedInContext, validationMessages);

            List<CronExpressionDecryptModel> decryptExpressions =
                auditList.Where(x => !string.IsNullOrEmpty(x.CronExpression) && x.AuditConductId == Guid.Empty)
                .Select(x => new CronExpressionDecryptModel
                {
                    AuditId = x.AuditId,
                    CronExpression = x.CronExpression,
                    StartDate = x.ScheduleStartDate.Value,
                    EndDate = x.ScheduleEndDate.Value
                }).Distinct().ToList();

            //var decryptExpressions = auditList.Where(x => !string.IsNullOrEmpty(x.CronExpression) && x.AuditConductId != Guid.Empty).GroupBy(x => new
            //{
            //    AuditId = x.AuditId,
            //    CronExpression = x.CronExpression,
            //    StartDate = x.CreatedDatetime,
            //    EndDate = x.Deadline
            //})
            //.Where(g => g.Count() == 1)
            //.Select(g => g.Key);

            List<AuditConductTimelineOutputModel> filteredAuditList = new List<AuditConductTimelineOutputModel>();
            foreach (var decryptModel in decryptExpressions)
            {
                DateTime start = auditTimelineInputModel.StartDate > decryptModel.StartDate ? auditTimelineInputModel.StartDate : decryptModel.StartDate;
                DateTime end = auditTimelineInputModel.EndDate <= decryptModel.EndDate ? auditTimelineInputModel.EndDate : decryptModel.EndDate;

                DateTime startDate = new DateTime(start.Year, start.Month, start.Day, 0, 0, 0, DateTimeKind.Utc);
                DateTime endDate = new DateTime(end.Year, end.Month, end.Day, 23, 59, 59, DateTimeKind.Utc);

                var audit = auditList.Where(x => x.AuditId == decryptModel.AuditId && x.CronExpression == decryptModel.CronExpression && (x.AuditConductId == null || x.AuditConductId == Guid.Empty)).FirstOrDefault();
                var dateList = CronHelper.GenerateDates(decryptModel.CronExpression, startDate, endDate, audit.SpanInYears ?? 0, audit.SpanInMonths ?? 0, audit.SpanInDays ?? 0);

                //filter dateList
                if (dateList != null && dateList.Any())
                {
                    foreach (var date in dateList.ToList())
                    {
                        if (auditList.Where(x => x.CronStartDate.HasValue).Any(x => x.CronStartDate == date.StartTime && x.CronEndDate == date.EndTime && x.AuditId == decryptModel.AuditId))
                        //if (auditList.Where(x => x.CronStartDate.HasValue).Any(x => TimeZoneInfo.ConvertTime(x.CronStartDate.Value, TimeZoneInfo.FindSystemTimeZoneById(loggedInContext.TimeZoneString)) == date.StartTime && x.CronEndDate.Value == date.EndTime && x.AuditId == decryptModel.AuditId))
                        {
                            dateList.Remove(date);
                        }
                    }
                }

                var recurringAudits = from aud in auditList.Where(x => x.AuditId == decryptModel.AuditId && x.CronExpression == decryptModel.CronExpression && (x.AuditConductId == null || x.AuditConductId == Guid.Empty)).ToList()
                             from dates in dateList
                             where dates.StartTime.Date >= DateTime.Now.Date 
                             select new AuditConductTimelineOutputModel
                             {
                                 AuditConductId = aud.AuditConductId,
                                 AuditConductName = aud.AuditConductName,
                                 AuditId = aud.AuditId,
                                 AuditName = aud.AuditName,
                                 ConductScore = 0,
                                 CreatedByUserName = aud.CreatedByUserName,
                                 CreatedDatetime = dates.StartTime,
                                 CronExpression = aud.CronExpression,
                                 Deadline = dates.EndTime,
                                 EndDate = aud.EndDate,
                                 InboundPercent = aud.InboundPercent,
                                 IsCompleted = aud.IsCompleted,
                                 IsRecurring = aud.IsRecurring,
                                 OutboundPercent = aud.OutboundPercent,
                                 StartDate = aud.StartDate,
                                 TotalAnswers = aud.TotalAnswers,
                                 TotalQuestions = aud.TotalQuestions,
                                 TotalValidAnswers = aud.TotalValidAnswers,
                                 LastAnswerdDateTime = aud.LastAnswerdDateTime,
                                 FirstAnswerdDateTime = aud.FirstAnswerdDateTime
                             };

                filteredAuditList.AddRange(recurringAudits);
            }
            var conductedAudits = from aud in auditList.Where(x => x.AuditConductId != Guid.Empty && x.AuditConductId != null).ToList()
                          select new AuditConductTimelineOutputModel
                          {
                              AuditConductId = aud.AuditConductId,
                              AuditConductName = aud.AuditConductName,
                              AuditId = aud.AuditId,
                              AuditName = aud.AuditName,
                              ConductScore = 0,
                              CreatedByUserName = aud.CreatedByUserName,
                              CreatedDatetime = aud.CreatedDatetime,
                              CronExpression = aud.CronExpression,
                              Deadline = aud.Deadline,
                              EndDate = aud.EndDate,
                              InboundPercent = aud.InboundPercent,
                              IsCompleted = aud.IsCompleted,
                              IsRecurring = aud.IsRecurring,
                              OutboundPercent = aud.OutboundPercent,
                              StartDate = aud.StartDate,
                              TotalAnswers = aud.TotalAnswers,
                              TotalQuestions = aud.TotalQuestions,
                              TotalValidAnswers = aud.TotalValidAnswers,
                              LastAnswerdDateTime = aud.LastAnswerdDateTime,
                              FirstAnswerdDateTime = aud.FirstAnswerdDateTime,
                              CronStartDate = aud.CronStartDate,
                              ProjectId = aud.ProjectId,
                              CronEndDate = aud.CronEndDate
                          };
            filteredAuditList.AddRange(conductedAudits);
            return filteredAuditList.Distinct().ToList();
        }
    }
}
