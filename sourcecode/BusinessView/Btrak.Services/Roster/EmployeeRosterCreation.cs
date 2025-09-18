using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using Btrak.Models.MasterData;
using Btrak.Models.Roster;
using Btrak.Services.Audit;
using Btrak.Services.MasterData;
using BTrak.Common;
using BTrak.Common.Texts;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Btrak.Services.Roster
{
    public class EmployeeRosterCreation : IEmployeeRosterCreation
    {
        private readonly RatesheetRepository _ratesheetRepository;
        private readonly IAuditService _auditService;
        private readonly EmployeeRepository _employeeRepository;
        private readonly IMasterDataManagementService _masterDataManagementRepository;
        private readonly ShiftTimingRepository _shiftTimingRepository;
        private readonly RosterRepository _rosterRepository;

        public EmployeeRosterCreation(RatesheetRepository ratesheetRepository, EmployeeRepository employeeRepository, IAuditService auditService,
            ShiftTimingRepository shiftTimingRepository, IMasterDataManagementService masterDataManagementRepository,
            RosterRepository rosterRepository)
        {
            _ratesheetRepository = ratesheetRepository;
            _auditService = auditService;
            _employeeRepository = employeeRepository;
            _shiftTimingRepository = shiftTimingRepository;
            _masterDataManagementRepository = masterDataManagementRepository;
            _rosterRepository = rosterRepository;
        }

        public List<EmployeeBudget> GetBudgetForEachEmployee(RosterInputModel rosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, Dictionary<Guid, int> employeeCounter)
        {
            List<EmployeeBudget> employeeBudgetList = new List<EmployeeBudget>();

            try
            {
                List<EmployeeOutputModel> employeeModels = LoadEmployeeDetails(rosterInputModel.rosterBasicDetails.BranchId, loggedInContext, validationMessages);
                List<HolidaysOutputModel> holidaysList = GetHolidays(loggedInContext, validationMessages);

                Guid[] employeeIds = employeeModels.Where(x => x.EmployeeId.HasValue).Select(x => x.EmployeeId.Value).Distinct().ToArray();
                string employeeJson = JsonConvert.SerializeObject(employeeIds);
                List<RosterEmployeeLeave> rosterEmployeeLeaves = _rosterRepository.GetEmployeeRosterLeaveDates(rosterInputModel.rosterBasicDetails, employeeJson, loggedInContext, validationMessages);
                List<RosterEmployeeUnavailability> rosterUnavailableEmployees = _rosterRepository.GetEmployeeRosterUnavailability(rosterInputModel.rosterBasicDetails, employeeJson, loggedInContext, validationMessages);
                if (employeeModels.Count <= 0)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = LangText.NotEmptyEmployeeDetails
                    });
                }

                if (validationMessages.Count > 0)
                    return null;

                if (rosterInputModel.rosterShiftDetails.Count > 0)
                {
                    ShiftWiseEmployeeRosterInputModel shiftWiseEmployeeRosterInputModel = new ShiftWiseEmployeeRosterInputModel();
                    shiftWiseEmployeeRosterInputModel.StartDate = rosterInputModel.rosterBasicDetails.RostStartDate;
                    shiftWiseEmployeeRosterInputModel.EndDate = rosterInputModel.rosterBasicDetails.RostEndDate;
                    shiftWiseEmployeeRosterInputModel.ShiftString = JsonConvert.SerializeObject(rosterInputModel.rosterShiftDetails.Select(x => x.shiftId).ToList());
                    shiftWiseEmployeeRosterInputModel.Includeholidays = rosterInputModel.rosterBasicDetails.IncludeHolidays;
                    shiftWiseEmployeeRosterInputModel.IncludeWeekends = rosterInputModel.rosterBasicDetails.IncludeWeekends;
                    shiftWiseEmployeeRosterInputModel.BranchId = rosterInputModel.rosterBasicDetails.BranchId;
                    List<RosterPlan> plans = _rosterRepository.LoadShiftwiseEmployeeForRoster(shiftWiseEmployeeRosterInputModel, loggedInContext, validationMessages);
                    employeeBudgetList = plans.Select(plan => new EmployeeBudget
                    {
                        BudgetDate = plan.PlanDate,
                        DepartmentId = plan.DepartmentId,
                        DepartmentName = plan.DepartmentName,
                        EmployeeId = plan.EmployeeId.Value,
                        EmployeeName = plan.EmployeeName,
                        EmployeeProfileImage = plan.EmployeeProfileImage,
                        FromTime = plan.FromTime,
                        ToTime = plan.ToTime,
                        TotalBudget = plan.TotalRate.HasValue ? plan.TotalRate.Value : 0,
                        IsPermanent = plan.IsPermanent.HasValue ? plan.IsPermanent.Value : false,
                        ShiftId = plan.ShiftId,
                        CurrencyCode = plan.CurrencyCode,
                        JoiningDate = employeeModels.Find(x => x.EmployeeId == plan.EmployeeId).DateOfJoining,
                        BudgetPerHour = plan.TotalRate.HasValue ? plan.TotalRate.Value / Convert.ToDecimal(plan.ToTime.Value.Subtract(plan.FromTime.Value).TotalHours) : 0
                    }).ToList();

                    employeeBudgetList.Select(X=> X.EmployeeId).Distinct().ToList().ForEach(x =>
                    {
                        if (!employeeCounter.ContainsKey(x))
                            employeeCounter.Add(x, 0);
                    });
                }

                EmployeeBudget employeeBudget;

                List<RosterEmployeeRatesOutput> employeerates = new List<RosterEmployeeRatesOutput>();
                foreach (WorkingDays day in rosterInputModel.workingDays)
                {
                    var budgetvalue = employeeBudgetList.Where(x => x.BudgetDate == day.ReqDate).Select(x => x.EmployeeId).ToArray();
                    var employees = employeeModels.Where(x => !budgetvalue.Contains(x.EmployeeId.Value)).Select(x => x.EmployeeId.Value).ToList();
                    if (employees != null && employees.Count > 0)
                    {
                        RosterEmployeeRatesInput rosterEmployeeRatesInput = new RosterEmployeeRatesInput();
                        rosterEmployeeRatesInput.CreatedDate = day.ReqDate;
                        rosterEmployeeRatesInput.StartTime = new DateTime(2020, 7, 15, AppConstants.DefaultStartTime.Hours, 0, 0).AddMinutes(rosterInputModel.TimeZone);
                        rosterEmployeeRatesInput.EndTime = new DateTime(2020, 7, 15, AppConstants.DefaultStartTime.Hours + rosterInputModel.rosterBasicDetails.RostMaxWorkHours, 0, 0).AddMinutes(rosterInputModel.TimeZone);
                        rosterEmployeeRatesInput.EmployeeIdJson = JsonConvert.SerializeObject(employees);
                        var employeeratesList = _rosterRepository.GetEmployeeRatesFromRateTags(rosterEmployeeRatesInput, loggedInContext, validationMessages);
                        employeerates.AddRange(employeeratesList);
                    }
                }

                if (employeerates.Count <= 0 && employeeBudgetList.Count <= 0)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = LangText.NotEmptyRateSheetDetails
                    });
                }
                var rateCount = employeerates.Where(x => x.Rate > 0).Select(x => x.EmployeeId).Distinct().Count();
                var budgetEmployeeCount = employeeBudgetList.Where(x => x.TotalBudget > 0).Select(x => x.EmployeeId).Distinct().Count();
                if ((rateCount + budgetEmployeeCount) <
                    employeeModels.Count)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = LangText.NotSufficientRateSheetDetails
                    });
                }

                if (employeerates.Count > 0)
                {
                    foreach (EmployeeOutputModel employee in employeeModels)
                    {
                        if (employee.EmployeeId.HasValue && !employeeCounter.ContainsKey(employee.EmployeeId.Value))
                        {
                            employeeCounter.Add(employee.EmployeeId.Value, 0);

                            foreach (WorkingDays day in rosterInputModel.workingDays)
                            {
                                int isOnLeave = rosterEmployeeLeaves.Where(x => day.ReqDate >= x.LeaveDateFrom && day.ReqDate <= x.LeaveDateTo && x.EmployeeId == employee.EmployeeId).Count();
                                if (isOnLeave > 0)
                                {
                                    continue;
                                }

                                int isAvailable = rosterUnavailableEmployees.Where(x => x.PlanDate == day.ReqDate && x.EmployeeId == employee.EmployeeId).Count();
                                if (isAvailable > 0)
                                {
                                    continue;
                                }

                                decimal? rate = 0;
                                //List<EmployeeRateSheetDetailsApiReturnModel> empRateQuery = employeeRatesheetDetails
                                //    .Where(x => x.RateSheetEmployeeId == employee.EmployeeId).ToList();
                                //empRateQuery = GetEmployeeRateByDay(empRateQuery, day, holidaysList);
                                employeeBudget = new EmployeeBudget();
                                employeeBudget.BudgetDate = day.ReqDate;
                                employeeBudget.EmployeeId = employee.EmployeeId.Value;
                                employeeBudget.EmployeeName = string.Join(" ", employee.FirstName, employee.SurName);
                                employeeBudget.EmployeeProfileImage = employee.ProfileImage;
                                employeeBudget.ShiftId = employee.ShiftTimingId;
                                employeeBudget.DepartmentId = employee.DepartmentId;
                                employeeBudget.DepartmentName = employee.DepartmentName;
                                employeeBudget.JoiningDate = employee.DateOfJoining;

                                RosterEmployeeRatesOutput rosterEmployeeRatesOutput = employeerates.FirstOrDefault(x => x.EmployeeId == employee.EmployeeId && x.CreatedDate == day.ReqDate);
                                //EmployeeRateSheetDetailsApiReturnModel returnModel = empRateQuery.FirstOrDefault();
                                if (rosterEmployeeRatesOutput == null)
                                {
                                    employeeBudget.CurrencyCode = AppConstants.DefaultCurrencyCode;
                                    rate = 0;
                                }
                                else
                                {
                                    rate = Convert.ToDecimal(rosterEmployeeRatesOutput.Rate);
                                    if (rosterEmployeeRatesOutput.IsPermanent)
                                    {
                                        employeeBudget.IsPermanent = true;
                                        employeeBudget.TotalBudget = rate.HasValue ? rate.Value : 0;
                                    }
                                    else
                                    {
                                        employeeBudget.TotalBudget = rate.HasValue ? rate.Value : 0;
                                    }
                                }
                                int dividend = AppConstants.DefaultStartTime.Hours + rosterInputModel.rosterBasicDetails.RostMaxWorkHours;

                                employeeBudget.BudgetPerHour = rate.HasValue ? rate.Value / dividend : 0;
                                employeeBudgetList.Add(employeeBudget);
                            }
                        }
                    }
                }
                return employeeBudgetList;
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBudgetForEachEmployee", "EmployeeRosterCreation ", ex.Message), ex);

                return employeeBudgetList;
            }
        }

        private List<EmployeeRateSheetDetailsApiReturnModel> GetEmployeeRateByDay(List<EmployeeRateSheetDetailsApiReturnModel> empRateQuery, WorkingDays day, List<HolidaysOutputModel> holidaysList)
        {
            if (!(day.IsHoliday || holidaysList.Any(x => x.Date == day.ReqDate)))
            {
                return empRateQuery.Where(x => x.RateSheetForName.Contains("Regular")).ToList();
            }
            else
            {
                return empRateQuery.Where(x => !x.RateSheetForName.Contains("Regular")).ToList();
            }
        }

        public List<EmployeeOutputModel> LoadEmployeeDetails(Guid? branchId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetAllEmployees." + "Logged in User Id=" + loggedInContext);

            int page = 1, totalPageCount = 0, pageRefCount = 0, pageSize = 1000;
            List<EmployeeOutputModel> employeeModels = new List<EmployeeOutputModel>();
            EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel = new EmployeeSearchCriteriaInputModel();
            employeeSearchCriteriaInputModel.BranchId = branchId == null || branchId == Guid.Empty ? null : branchId;
            employeeSearchCriteriaInputModel.SortBy = string.Empty;
            employeeSearchCriteriaInputModel.SortDirectionAsc = true;
            employeeSearchCriteriaInputModel.PageNumber = page;
            employeeSearchCriteriaInputModel.PageSize = pageSize;
            employeeSearchCriteriaInputModel.SearchText = string.Empty;

            _auditService.SaveAudit(AppCommandConstants.GetAllEmployeesCommandId, employeeSearchCriteriaInputModel, loggedInContext);

            LoggingManager.Debug(employeeSearchCriteriaInputModel.ToString());
            do
            {
                pageRefCount += pageSize;
                employeeSearchCriteriaInputModel.PageNumber = page;
                List<EmployeeOutputModel> employeeOutputModels = _employeeRepository.GetAllEmployees(employeeSearchCriteriaInputModel, loggedInContext, validationMessages);
                if (employeeOutputModels.Count > 0)
                {
                    totalPageCount = employeeOutputModels[0].TotalCount;
                }
                employeeModels.AddRange(employeeOutputModels);
                page++;
            } while (totalPageCount > pageRefCount);

            return employeeModels;

        }

        public List<EmployeeRateSheetDetailsApiReturnModel> LoadRatesheetForAllEmployee(RosterInputModel rosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            int page = 1, totalPageCount = 0, pageRefCount = 0, pageSize = 100;

            EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel = new EmployeeDetailSearchCriteriaInputModel();
            employeeDetailSearchCriteriaInputModel.EmployeeDetailType = "All";
            employeeDetailSearchCriteriaInputModel.BranchId = rosterInputModel.rosterBasicDetails.BranchId;
            employeeDetailSearchCriteriaInputModel.PageNumber = page;
            employeeDetailSearchCriteriaInputModel.PageSize = pageSize;
            List<EmployeeRateSheetDetailsApiReturnModel> employeeRatesheetDetails = new List<EmployeeRateSheetDetailsApiReturnModel>();

            do
            {
                pageRefCount += pageSize;
                employeeDetailSearchCriteriaInputModel.PageNumber = page;
                List<EmployeeRateSheetDetailsApiReturnModel> employeeRateSheetDetailsApiReturnModels = _ratesheetRepository.GetEmployeeRateSheetDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages);
                if (employeeRateSheetDetailsApiReturnModels.Count > 0)
                {
                    var totalCount = employeeRateSheetDetailsApiReturnModels[0].TotalCount;
                    if (totalCount != null)
                        totalPageCount = totalCount.Value;
                }
                employeeRatesheetDetails.AddRange(employeeRateSheetDetailsApiReturnModels);
                page++;
            } while (totalPageCount > pageRefCount);

            return employeeRatesheetDetails;
        }

        public List<ShiftWeekSearchOutputModel> GetShiftWeekData(Guid shiftTimingId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            ShiftWeekSearchInputModel shiftWeekSearchInputModel = new ShiftWeekSearchInputModel();
            shiftWeekSearchInputModel.ShiftTimingId = shiftTimingId;
            return _shiftTimingRepository.GetShiftWeek(shiftWeekSearchInputModel, loggedInContext, validationMessages);
        }

        public List<HolidaysOutputModel> GetHolidays(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            HolidaySearchCriteriaInputModel holidaySearchCriteriaInputModel = new HolidaySearchCriteriaInputModel();
            List<HolidaysOutputModel> holidaysList = _masterDataManagementRepository.GetHolidays(holidaySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            Parallel.ForEach(holidaysList, holiday =>
            {
                holiday.WeekOffDays = holiday.WeekOff != null ? holiday.WeekOff.Split(',').ToList() : new List<string>();
            });

            return holidaysList;
        }
    }
}