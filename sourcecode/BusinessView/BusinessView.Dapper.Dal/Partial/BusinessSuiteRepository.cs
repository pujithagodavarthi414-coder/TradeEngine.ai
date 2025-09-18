using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Widgets;
using BTrak.Common;
using Dapper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;

namespace Btrak.Dapper.Dal.Partial
{
    public class BusinessSuiteRepository : BaseRepository
    {
        private readonly WidgetRepository _widgetRepository = new WidgetRepository();
        private DateTime? _dateFrom;
        private DateTime? _dateTo;
        private DateTime? _date;

        public dynamic UpsertData(Dictionary<string, object> upsertDataInputModel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext = null)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();

                    _dateFrom = null;
                    _dateTo = null;
                    _date = null;

                    bool isForFilters = true;

                    bool addOperationPerformedBy = true;

                    List<Temp> paramsList = new List<Temp>();

                    List<FilterKeyValuePair> filters = new List<FilterKeyValuePair>();

                    string spName = upsertDataInputModel.Any(p => p.Key == "storedProcedureName") ? upsertDataInputModel["storedProcedureName"].ToString() : upsertDataInputModel["SpName"].ToString();
                    var isValidProc = _widgetRepository.IsValidProcedure(spName, validationMessages);

                    if (validationMessages.Count > 0)
                    {
                        return null;
                    }

                    foreach (var dic in upsertDataInputModel)
                    {
                        if (dic.Key != "SpName")
                        {
                            if (dic.Key == "@OperationsPerformedBy")
                            {
                                addOperationPerformedBy = false;
                            }

                            Temp param = new Temp
                            {
                                Key = dic.Key,
                                Value = dic.Value?.ToString()
                            };
                            paramsList.Add(param);

                            if (dic.Key != "isForFilters" && dic.Key != "workspaceId" && dic.Key != "dashboardId")
                            {
                                vParams.Add(dic.Key, dic.Value);
                            }

                            if (dic.Key == "isForFilters" && (string)dic.Value == "false")
                            {
                                isForFilters = false;
                            }
                        }
                    }

                    if (isForFilters == true)
                    {
                        var dashboardId = paramsList.FirstOrDefault(p => p.Key == "workspaceId")?.Value;

                        var dashboardAppId = paramsList.FirstOrDefault(p => p.Key == "dashboardId")?.Value;

                        if (dashboardId != null || dashboardAppId != null)
                        {
                            Guid? dashboardGuid = null;

                            if (dashboardId != null)
                            {
                                dashboardGuid = new Guid(dashboardId);
                            }

                            Guid? dashboardAppGuid = null;

                            if (dashboardAppId != null)
                            {
                                dashboardAppGuid = new Guid(dashboardAppId);
                            }

                            DynamicDashboardFilterModel dashboardFilterModel = new DynamicDashboardFilterModel
                            {
                                DashboardAppId = dashboardAppGuid,
                                DashboardId = dashboardGuid
                            };

                            filters = _widgetRepository.GetDashboardFilters(dashboardFilterModel, loggedInContext, validationMessages);
                        }


                        vParams = new DynamicParameters();

                        foreach (var filter in paramsList)
                        {
                            if (filter.Key != "isForFilters" && filter.Key != "workspaceId" && filter.Key != "dashboardId")
                            {
                                if (!string.IsNullOrEmpty(filter.Value))
                                {
                                    if (filter.Value == "@UserId")
                                    {
                                        filter.Value = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "User" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                    }
                                    else if (filter.Value == "@ProjectId")
                                    {
                                        filter.Value = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Project" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                    }
                                    else if (filter.Value == "@AuditId")
                                    {
                                        filter.Value = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Audit" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                    }
                                    else if (filter.Value == "@BusinessUnitIds")
                                    {
                                        filter.Value = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "BusinessUnit" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                    }
                                    else if (filter.Value == "@EntityId")
                                    {
                                        filter.Value = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Entity" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                    }
                                    else if (filter.Value == "@DesignationId")
                                    {
                                        filter.Value = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Designation" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                    }
                                    else if (filter.Value == "@BranchId")
                                    {
                                        filter.Value = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Branch" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                    }
                                    else if (filter.Value == "@RoleId")
                                    {
                                        filter.Value = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Role" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                    }
                                    else if (filter.Value == "@DepartmentId")
                                    {
                                        filter.Value = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Department" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                    }
                                    else if (filter.Value == "@IsFinancialYear")
                                    {
                                        var IsFinancialYear = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "FinancialYear" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                        if (IsFinancialYear == "true")
                                        {
                                            filter.Value = "1";
                                        }
                                        else if (IsFinancialYear == "false")
                                        {
                                            filter.Value = "0";
                                        }
                                        else
                                        {
                                            filter.Value = null;
                                        }
                                    }
                                    else if (filter.Value == "@IsActiveEmployeesOnly")
                                    {
                                        var IsFinancialYear = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "ActiveEmployees" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                        if (IsFinancialYear == "true")
                                        {
                                            filter.Value = "1";
                                        }
                                        else if (IsFinancialYear == "false")
                                        {
                                            filter.Value = "0";
                                        }
                                        else
                                        {
                                            filter.Value = null;
                                        }
                                    }
                                    else if (filter.Value == "@IsActive")
                                    {
                                        var IsFinancialYear = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "ActiveEmployees" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                        if (IsFinancialYear == "true")
                                        {
                                            filter.Value = "1";
                                        }
                                        else if (IsFinancialYear == "false")
                                        {
                                            filter.Value = "0";
                                        }
                                        else
                                        {
                                            filter.Value = null;
                                        }
                                    }
                                    else if (filter.Value == "@Month")
                                    {
                                        filter.Value = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Month" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                    }
                                    else if (filter.Value == "@Year")
                                    {
                                        filter.Value = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Year" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;
                                    }
                                    else if (filter.Value == "@OperationsPerformedBy")
                                    {
                                        filter.Value = loggedInContext.LoggedInUserId.ToString();
                                    }
                                    else if (filter.Value == "@CompanyId")
                                    {
                                        filter.Value = loggedInContext.CompanyGuid.ToString();
                                    }
                                    else if (filter.Value == "@DateFrom" || filter.Value == "@DateTo" || filter.Value == "@Date")
                                    {
                                        var dateValue = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Date" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;

                                        if (dateValue == "lastMonth" || dateValue == "thisMonth" || dateValue == "lastWeek" || dateValue == "nextWeek")
                                        {
                                            DateFromDateTo(dateValue);
                                        }
                                        else if (!string.IsNullOrEmpty(dateValue))
                                        {
                                            var obj = JsonConvert.DeserializeObject<DateFilterModel>(dateValue);
                                            if (obj.Date != null && obj.DateFrom == null && obj.DateTo == null)
                                            {
                                                _date = obj.Date;
                                            }
                                            else
                                            {
                                                _dateFrom = obj.DateFrom;
                                                _dateTo = obj.DateTo;
                                            }
                                        }
                                        if (filter.Value == "@DateFrom")
                                        {
                                            filter.Value = _dateFrom != null ? _dateFrom.ToString() : null;
                                        }
                                        else if (filter.Value == "@DateTo")
                                        {
                                            filter.Value = _dateTo != null ? _dateTo.ToString() : null;
                                        }
                                        else if (filter.Value == "@Date")
                                        {
                                            filter.Value = _date != null ? _date.ToString() : null;
                                        }
                                    }
                                    else if (filter.Value == "@CurrentDateTime")
                                    {
                                        var indianTimeDetails = TimeZoneHelper.GetIstTime();
                                        DateTimeOffset? buttonClickedDate = indianTimeDetails?.UserTimeOffset;

                                        if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
                                        {
                                            LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                                            var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                                            buttonClickedDate = userTimeDetails?.UserTimeOffset;
                                        }
                                        filter.Value = buttonClickedDate.Value.DateTime.ToString();
                                    }
                                }
                                vParams.Add(filter.Key, filter.Value);
                            }
                        }
                    }

                    if (addOperationPerformedBy)
                    {
                        vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    }

                    return vConn.Query<dynamic>(upsertDataInputModel["SpName"].ToString(), vParams, commandType: CommandType.StoredProcedure, commandTimeout: 0).ToList();
                    //return vConn.Query<dynamic>(StoredProcedureConstants.SpUpsertBranch, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertData", "BusinessSuiteRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertBranch);
                return null;
            }
        }

        public void DateFromDateTo(string filterName)
        {
            _dateFrom = new DateTime();
            _dateTo = new DateTime();
            DateTime now = DateTime.Today;
            if (filterName == "lastMonth")
            {
                var dFirstDayOfThisMonth = DateTime.Today.AddDays(-(DateTime.Today.Day - 1));
                _dateTo = dFirstDayOfThisMonth.AddDays(-1);
                _dateFrom = dFirstDayOfThisMonth.AddMonths(-1);
                //_dateFrom = new DateTime(now.Year, now.Month - 1, 1);
                //_dateTo = new DateTime(now.Year, now.Month, 1).AddDays(-1);
            }
            else if (filterName == "thisMonth")
            {
                var dFirstDayOfThisMonth = DateTime.Today.AddDays(-(DateTime.Today.Day - 1));
                _dateFrom = DateTime.Today.AddDays(-(DateTime.Today.Day - 1));
                _dateTo = dFirstDayOfThisMonth.AddMonths(1).AddDays(-1);

            }
            else if (filterName == "lastWeek")
            {
                _dateFrom = FirstDayOfWeek(now.AddDays(-7));
                _dateTo = LastDayOfWeek(now.AddDays(-7));
            }
            else if (filterName == "nextWeek")
            {
                _dateFrom = FirstDayOfWeek(now.AddDays(7));
                _dateTo = LastDayOfWeek(now.AddDays(7));
            }
        }

        public static DateTime FirstDayOfWeek(DateTime date)
        {
            DayOfWeek fdow = CultureInfo.CurrentCulture.DateTimeFormat.FirstDayOfWeek;
            int offset = fdow - date.DayOfWeek;
            DateTime fdowDate = date.AddDays(offset);
            return fdowDate.AddDays(1);
        }

        public static DateTime LastDayOfWeek(DateTime date)
        {
            DateTime ldowDate = FirstDayOfWeek(date).AddDays(6);
            return ldowDate;
        }

    }

    public class Temp
    {
        public string Key { get; set; }
        public string Value { get; set; }
    }
}