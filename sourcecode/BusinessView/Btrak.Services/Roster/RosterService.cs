using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Currency;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using Btrak.Models.MasterData;
using Btrak.Models.Notification;
using Btrak.Models.Roster;
using Btrak.Models.TimeSheet;
using Btrak.Models.User;
using Btrak.Services.Audit;
using Btrak.Services.Email;
using Btrak.Services.Helpers;
using Btrak.Services.MasterData;
using Btrak.Services.Notification;
using Btrak.Services.User;
using BTrak.Common;
using BTrak.Common.Constants;
using Hangfire;
using Newtonsoft.Json;

namespace Btrak.Services.Roster
{
    public class RosterService : IRosterService
    {
        private readonly IAuditService _auditService;
        private readonly IEmployeeRosterCreation _employeeRosterCreation;
        private readonly RosterRepository _rosterRepository;
        private readonly RosterValidationHelpers _rosterValidationHelpers;
        private readonly CompanyStructureRepository _companyStructureRepository;
        private readonly MasterTableRepository _masterTableRepository;
        private readonly GoalRepository _goalRepository;
        private readonly INotificationService _notificationService;
        private readonly IUserService _userService;
        private readonly IMasterDataManagementService _masterDataManagementService;
        private readonly IEmailService _emailService;

        public RosterService(IEmployeeRosterCreation employeeRosterCreation, RosterRepository rosterRepository, IAuditService auditService, RosterValidationHelpers rosterValidationHelpers, CompanyStructureRepository companyStructureRepository, MasterTableRepository masterTableRepository,
            UserRepository userRepository, GoalRepository goalRepository, INotificationService notificationService, IUserService userService, IMasterDataManagementService masterDataManagementService, IEmailService emailService)
        {
            _auditService = auditService;
            _rosterRepository = rosterRepository;
            _rosterValidationHelpers = rosterValidationHelpers;
            _companyStructureRepository = companyStructureRepository;
            _masterTableRepository = masterTableRepository;
            _goalRepository = goalRepository;
            _notificationService = notificationService;
            _userService = userService;
            _employeeRosterCreation = employeeRosterCreation;
            _masterDataManagementService = masterDataManagementService;
            _emailService = emailService;
        }

        public List<RosterPlanSolution> CreateRosterSolutions(RosterInputModel rosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateRosterPlan", "Roster Service"));
            LoggingManager.Debug(rosterInputModel?.ToString());

            Dictionary<Guid, int> employeeCounter = new Dictionary<Guid, int>();
            List<EmployeeBudget> employeeBudgetList = new List<EmployeeBudget>();
            List<ShiftWeekSearchOutputModel> shiftWeekSearchOutputModels = new List<ShiftWeekSearchOutputModel>();
            string currencyCode = string.Empty;

            if (_rosterValidationHelpers.CreateRosterSolutions(rosterInputModel, loggedInContext, validationMessages).Count > 0)
            {
                return null;
            }
            CompanySearchCriteriaInputModel searchCriteriaModel = new CompanySearchCriteriaInputModel { CompanyId = loggedInContext.CompanyGuid };
            CurrencySearchCriteriaInputModel currencySearchCriteriaInputModel = new CurrencySearchCriteriaInputModel { CompanyId = loggedInContext.CompanyGuid };

            LoggingManager.Info("Getting Company Detail by Id ");
            CompanyOutputModel companyList = _companyStructureRepository.SearchCompanies(searchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();
            if (companyList != null && companyList.CurrencyId.HasValue)
            {
                currencySearchCriteriaInputModel.CurrencyId = companyList.CurrencyId.Value;
                CurrencyOutputModel currencyOutputModel = _masterTableRepository.GetCurrencyList(currencySearchCriteriaInputModel, validationMessages, loggedInContext).FirstOrDefault();
                if (currencyOutputModel != null && currencyOutputModel.CurrencyId != null)
                    currencyCode = currencyOutputModel.CurrencyCode;
                else
                    currencyCode = AppConstants.DefaultCurrencyCode;
            }
            else
            {
                currencyCode = AppConstants.DefaultCurrencyCode;
            }

            employeeBudgetList = _employeeRosterCreation.GetBudgetForEachEmployee(rosterInputModel, loggedInContext, validationMessages, employeeCounter);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (rosterInputModel != null && rosterInputModel.rosterShiftDetails.Count > 0)
            {
                foreach (RosterShiftDetails shift in rosterInputModel.rosterShiftDetails)
                {
                    var shiftWeekData = _employeeRosterCreation.GetShiftWeekData(shift.shiftId, loggedInContext, validationMessages);
                    shiftWeekSearchOutputModels.AddRange(shiftWeekData);
                }
            }

            List<RosterPlanSolution> solutions = new List<RosterPlanSolution>();

            foreach (RostEmployeeSortOrder sortOrder in Enum.GetValues(typeof(RostEmployeeSortOrder)))
            {
                RosterPlanSolution plan = new RosterPlanSolution
                {
                    Solution = new RosterSolution { SolutionId = Guid.NewGuid(), SolutionName = sortOrder.ToString() }
                };
                plan.Plans = GetSolution(rosterInputModel, sortOrder, plan.Solution.SolutionId, employeeCounter, employeeBudgetList, shiftWeekSearchOutputModels, currencyCode);
                plan.Solution.Budget = plan.Plans.Sum(x => x.TotalRate).Value;
                solutions.Add(plan);
            }
            Guid? requestId;

            if (rosterInputModel != null && (rosterInputModel.RequestId != null && rosterInputModel.RequestId != Guid.Empty))
                requestId = rosterInputModel.RequestId;
            else
                requestId = CreateRosterRequest(rosterInputModel, solutions, loggedInContext, validationMessages);

            foreach (var solution in solutions)
            {
                if (requestId != null) solution.RequestId = requestId.Value;
            }
            return solutions.OrderBy(x => x.Solution.Budget).ToList();
        }

        public Guid? CreateRosterPlan(RosterPlanInputModel rosterPlanInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string url)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateRosterPlan", "Roster Service"));

            LoggingManager.Debug(rosterPlanInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertRosterCommandId, rosterPlanInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            if (rosterPlanInputModel != null)
            {
                string plans = JsonConvert.SerializeObject(rosterPlanInputModel.Plans);

                Guid? rosterRequest = _rosterRepository.CreateRosterPlan(rosterPlanInputModel, plans, loggedInContext, validationMessages);
                if (rosterRequest != null && rosterRequest.Value != Guid.Empty)
                {
                    var rosterdetails = GetRosterPlans(new RosterSearchInputModel() { RequestId = rosterPlanInputModel.RequestId, PageNumber = 0, PageSize = 1 }, loggedInContext, validationMessages).FirstOrDefault();

                    if (rosterPlanInputModel.BasicInput.IsApprove && rosterRequest.HasValue)
                    {
                        //var rosterdetails = GetRosterPlans(new RosterSearchInputModel() { RequestId = rosterPlanInputModel.RequestId }, loggedInContext, validationMessages).FirstOrDefault();

                        BackgroundJob.Enqueue(() => SendRosterMailsToManagerAndEmployeeAfterApproval(rosterPlanInputModel, loggedInContext, validationMessages, rosterdetails));

                        //Send pushNotifications for mobile
                        SendPushNotification(rosterPlanInputModel, loggedInContext, validationMessages);
                    }
                    else if (rosterPlanInputModel.BasicInput.IsSubmitted)
                    {
                        BackgroundJob.Enqueue(() => SendApproveEmailToManager(rosterPlanInputModel, loggedInContext, validationMessages, rosterdetails, url));
                    }
                }
                return rosterRequest;
            }

            return null;
        }

        public Guid? CreateRosterRequest(RosterInputModel rosterInputModel, List<RosterPlanSolution> rosterPlanSolutions, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<RosterSolution> rosterSolutions = new List<RosterSolution>();
            List<RosterPlan> rosterPlans = new List<RosterPlan>();
            foreach (RosterPlanSolution rosterPlanSolution in rosterPlanSolutions)
            {
                rosterSolutions.Add(rosterPlanSolution.Solution);
                rosterPlans.AddRange(rosterPlanSolution.Plans);
            }

            string basicInfo = JsonConvert.SerializeObject(rosterInputModel.rosterBasicDetails);
            string shiftDetails = JsonConvert.SerializeObject(rosterInputModel.rosterShiftDetails);
            string departmentDetails = JsonConvert.SerializeObject(rosterInputModel.rosterDepartmentDetails);
            string adHocDetails = JsonConvert.SerializeObject(rosterInputModel.rosterAdhocRequirement);
            string solutions = JsonConvert.SerializeObject(rosterSolutions);
            string plans = JsonConvert.SerializeObject(rosterPlans);

            _auditService.SaveAudit(AppCommandConstants.UpsertRosterCommandId, rosterInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? rosterRequest = _rosterRepository.CreateRosterRequest(rosterInputModel, basicInfo, solutions, plans, shiftDetails, departmentDetails, adHocDetails, loggedInContext, validationMessages);

            return rosterRequest;
        }

        public List<RosterSearchOutputModel> GetRosterPlans(RosterSearchInputModel rosterSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (rosterSearchInputModel != null)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRosterPlans", "Roster Service"));

                LoggingManager.Debug(rosterSearchInputModel.ToString());

                if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
                {
                    return null;
                }

                _auditService.SaveAudit(AppCommandConstants.UpsertRosterCommandId, rosterSearchInputModel, loggedInContext);
                List<RosterSearchOutputModel> rosterSearchOutputModels = _rosterRepository.GetRosterPlans(rosterSearchInputModel, loggedInContext, validationMessages);

                LoggingManager.Debug(rosterSearchInputModel.RequestId?.ToString());

                return rosterSearchOutputModels;
            }
            else
            {
                return null;
            }
        }

        public List<RosterPlanOutputModel> GetRosterPlanByRequest(RosterSearchInputModel rosterSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRosterPlanByRequest", "Roster Service"));

            LoggingManager.Debug(rosterSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertRosterCommandId, rosterSearchInputModel, loggedInContext);
            List<RosterPlanOutputModel> rosterPlans = _rosterRepository.GetRosterPlanByRequest(rosterSearchInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug(rosterSearchInputModel.RequestId?.ToString());

            return rosterPlans;
        }

        public RosterPlanSolutionOutput GetRosterSolutionsById(RosterInputModel rosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            RosterPlanSolutionOutput rosterRequestSolutions = _rosterRepository.GetRosterSolutionsById(rosterInputModel, loggedInContext, validationMessages);
            return rosterRequestSolutions;
        }

        public Guid? CheckRosterName(RosterInputModel rosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckRosterName", "Roster Service"));

            LoggingManager.Debug(rosterInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertRosterCommandId, rosterInputModel, loggedInContext);
            Guid? requestId = _rosterRepository.CheckRosterName(rosterInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug(rosterInputModel.RequestId?.ToString());

            return requestId;
        }

        public List<RosterTemplatePlanOutputModel> GetRosterTemplatePlanByRequest(RosterSearchInputModel rosterSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRosterTemplatePlanByRequest", "Roster Service"));

            LoggingManager.Debug(rosterSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertRosterCommandId, rosterSearchInputModel, loggedInContext);
            List<RosterTemplatePlanOutputModel> rosterPlans = _rosterRepository.GetRosterTemplatePlanByRequest(rosterSearchInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug(rosterSearchInputModel.RequestId?.ToString());

            return rosterPlans;
        }

        public List<RosterPlan> LoadShiftwiseEmployeeForRoster(ShiftWiseEmployeeRosterInputModel shiftWiseEmployeeRosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "LoadShiftwiseEmployeeForRoster", "Roster Service"));

            LoggingManager.Debug(shiftWiseEmployeeRosterInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertRosterCommandId, shiftWiseEmployeeRosterInputModel, loggedInContext);
            shiftWiseEmployeeRosterInputModel.ShiftString = JsonConvert.SerializeObject(shiftWiseEmployeeRosterInputModel.Shifts);
            List<RosterPlan> rosterPlans = _rosterRepository.LoadShiftwiseEmployeeForRoster(shiftWiseEmployeeRosterInputModel, loggedInContext, validationMessages);

            return rosterPlans;
        }

        private List<RosterPlan> GetSolution(RosterInputModel rosterInputModel, RostEmployeeSortOrder sortOrder, Guid solutionId,
            Dictionary<Guid, int> employeeCounter, List<EmployeeBudget> employeeBudgetList, List<ShiftWeekSearchOutputModel> shiftWeekSearchOutputModels, string currencyCode)
        {
            List<RosterPlan> rosterPlanList = new List<RosterPlan>();
            int numEmployees = rosterInputModel.rosterBasicDetails.RostEmployeeRequired;
            int numShifts = rosterInputModel.rosterShiftDetails.Count;
            int numDepartments = rosterInputModel.rosterDepartmentDetails.Select(x => x.DepartmentId).Distinct().Count();

            IEnumerable<int> allDays = Enumerable.Range(0, rosterInputModel.workingDays.Count);

            TimeSpan defaultStartTime = AppConstants.DefaultStartTime + TimeSpan.FromMinutes(rosterInputModel.TimeZone);
            ShiftOrDepartment shiftOrDepartment = new ShiftOrDepartment();
            foreach (int day in allDays)
            {
                employeeCounter.Keys.ToList().ForEach(x => employeeCounter[x] = 0);

                shiftOrDepartment.reqDate = rosterInputModel.workingDays[day].ReqDate;
                shiftOrDepartment.maxCount = rosterInputModel.rosterBasicDetails.RostMaxWorkDays;
                shiftOrDepartment.maxHours = rosterInputModel.rosterBasicDetails.RostMaxWorkHours;

                if (numShifts > 0)
                {
                    GetShiftDetails(rosterInputModel, shiftOrDepartment, sortOrder, solutionId, employeeBudgetList, ref employeeCounter, shiftWeekSearchOutputModels, ref rosterPlanList, currencyCode, defaultStartTime);
                }
                else if (numDepartments > 0)
                {
                    GetDepartmentDetails(rosterInputModel, shiftOrDepartment, sortOrder, solutionId, employeeBudgetList, ref employeeCounter, shiftWeekSearchOutputModels, ref rosterPlanList, currencyCode, defaultStartTime);
                }
                else
                {
                    GetEmployeeDetails(shiftOrDepartment, numEmployees, sortOrder, solutionId, employeeBudgetList, ref employeeCounter, shiftWeekSearchOutputModels, ref rosterPlanList, currencyCode, defaultStartTime);
                }
                if (rosterInputModel.rosterAdhocRequirement.Count > 0)
                {
                    foreach (RosterAdhocRequirement adhoc in rosterInputModel.rosterAdhocRequirement)
                    {
                        ShiftOrDepartment adhocDetails = new ShiftOrDepartment();
                        adhocDetails.reqDate = rosterInputModel.workingDays[day].ReqDate;
                        adhocDetails.maxCount = rosterInputModel.rosterBasicDetails.RostMaxWorkDays;
                        adhocDetails.adHocDetails = adhoc;
                        if (adhoc.NoOfEmployeeRequired != 0 || adhoc.EmployeeSpecifcation.Length > 0)
                            GetEmployeeDetails(shiftOrDepartment, adhoc.NoOfEmployeeRequired, sortOrder, solutionId, employeeBudgetList, ref employeeCounter, shiftWeekSearchOutputModels, ref rosterPlanList, currencyCode, defaultStartTime);

                    }
                }
            }

            //return new { rosterPlan = rosterPlan.ToList(), rosterPlanList };
            return rosterPlanList;
        }

        private void GetShiftDetails(RosterInputModel rosterInputModel, ShiftOrDepartment shiftOrDepartment,
            RostEmployeeSortOrder sortOrder, Guid solutionId, List<EmployeeBudget> employeeBudgetList, ref Dictionary<Guid, int> employeeCounter,
            List<ShiftWeekSearchOutputModel> shiftWeekSearchOutputModels, ref List<RosterPlan> rosterPlanList, string currencyCode, TimeSpan defaultStartTime)
        {
            IEnumerable<int> allShifts = Enumerable.Range(0, rosterInputModel.rosterShiftDetails.Count);

            foreach (int shift in allShifts)
            {
                if (rosterInputModel.rosterShiftDetails[shift].NoOfEmployeeRequired > 0 || rosterInputModel.rosterShiftDetails[shift].EmployeeSpecifcation.Count() > 0)
                {
                    var shiftDetails = rosterInputModel.rosterShiftDetails[shift];
                    ShiftOrDepartment sod = new ShiftOrDepartment
                    {
                        reqDate = shiftOrDepartment.reqDate,
                        shiftDetails = shiftDetails,
                        maxCount = rosterInputModel.rosterBasicDetails.RostMaxWorkDays,
                        maxHours = rosterInputModel.rosterBasicDetails.RostMaxWorkHours
                    };
                    if (rosterInputModel.rosterDepartmentDetails.Count(x => x.ShiftId == shiftDetails.shiftId) > 0)
                    {
                        GetDepartmentDetails(rosterInputModel, sod, sortOrder, solutionId, employeeBudgetList, ref employeeCounter, shiftWeekSearchOutputModels, ref rosterPlanList, currencyCode, defaultStartTime);
                    }
                    else
                    {
                        GetEmployeeDetails(sod, shiftDetails.NoOfEmployeeRequired, sortOrder, solutionId, employeeBudgetList, ref employeeCounter, shiftWeekSearchOutputModels, ref rosterPlanList, currencyCode, defaultStartTime);
                    }
                }
            }
        }

        private void GetDepartmentDetails(RosterInputModel rosterInputModel, ShiftOrDepartment shiftOrDepartment,
            RostEmployeeSortOrder sortOrder, Guid solutionId, List<EmployeeBudget> employeeBudgetList, ref Dictionary<Guid, int> employeeCounter,
            List<ShiftWeekSearchOutputModel> shiftWeekSearchOutputModels, ref List<RosterPlan> rosterPlanList, string currencyCode, TimeSpan defaultStartTime)
        {
            List<RosterDepartmentDetails> allDepartments = rosterInputModel.rosterDepartmentDetails
                .Where(x => shiftOrDepartment.shiftDetails == null || (shiftOrDepartment.shiftDetails != null && shiftOrDepartment.shiftDetails.shiftId == x.ShiftId)).ToList();

            for (int dept = 0; dept < allDepartments.Count; dept++)
            {
                ShiftOrDepartment sod = new ShiftOrDepartment
                {
                    reqDate = shiftOrDepartment.reqDate,
                    shiftDetails = shiftOrDepartment.shiftDetails,
                    maxCount = shiftOrDepartment.maxCount,
                    maxHours = rosterInputModel.rosterBasicDetails.RostMaxWorkHours
                };
                var department = allDepartments[dept];
                if (department != null && department.NoOfEmployeeRequired > 0)
                {
                    sod.departmentDetails = department;
                    GetEmployeeDetails(sod, department.NoOfEmployeeRequired, sortOrder, solutionId, employeeBudgetList, ref employeeCounter, shiftWeekSearchOutputModels, ref rosterPlanList, currencyCode, defaultStartTime);
                }
            }
        }

        private void GetEmployeeDetails(ShiftOrDepartment shiftOrDepartment, int numEmployees, RostEmployeeSortOrder sortOrder,
            Guid solutionId, List<EmployeeBudget> employeeBudgetList, ref Dictionary<Guid, int> employeeCounter,
            List<ShiftWeekSearchOutputModel> shiftWeekSearchOutputModels, ref List<RosterPlan> rosterPlanList, string currencyCode, TimeSpan defaultStartTime)
        {
            if (numEmployees > 0)
            {
                var employeeQueriable = employeeBudgetList.Where(x => shiftOrDepartment.reqDate == x.BudgetDate).AsQueryable();
                if (shiftOrDepartment.departmentDetails != null)
                {
                    employeeQueriable = employeeQueriable.Where(x => x.DepartmentId != null && shiftOrDepartment.departmentDetails.DepartmentId == x.DepartmentId).AsQueryable();
                }
                if (shiftOrDepartment.shiftDetails != null)
                {
                    employeeQueriable = employeeQueriable.Where(x => x.ShiftId != null && shiftOrDepartment.shiftDetails.shiftId == x.ShiftId).AsQueryable();
                }

                var filteredEmployeeList = employeeQueriable.ToList();

                List<ShiftWeekSearchOutputModel> filterdShiftWeeks = shiftWeekSearchOutputModels.Where(x => x.ShiftTimingId == shiftOrDepartment.shiftDetails.shiftId).ToList();

                int requiredEmployee = 0;

                List<RosterPlan> adhocRosterlist = AdHocRequirementPlansCreation(solutionId, shiftOrDepartment, filteredEmployeeList, filterdShiftWeeks, ref requiredEmployee, ref employeeCounter, currencyCode, defaultStartTime);
                if (adhocRosterlist != null && adhocRosterlist.Count > 0)
                {
                    rosterPlanList.AddRange(adhocRosterlist);
                }

                for (int index = 0; index < filteredEmployeeList.Count; index++)
                {
                    if (numEmployees > requiredEmployee)
                    {
                        ShiftOrDepartment sod = new ShiftOrDepartment
                        {
                            reqDate = shiftOrDepartment.reqDate,
                            shiftDetails = shiftOrDepartment.shiftDetails,
                            departmentDetails = shiftOrDepartment.departmentDetails,
                            maxCount = shiftOrDepartment.maxCount,
                            maxHours = shiftOrDepartment.maxHours
                        };
                        var leastCountQuery = (from filtered in filteredEmployeeList
                                               join empCounter in employeeCounter on filtered.EmployeeId equals empCounter.Key
                                               select new { empCounter, filtered }).AsQueryable();

                        switch (sortOrder)
                        {
                            case RostEmployeeSortOrder.LowRate:
                                leastCountQuery = (from x in leastCountQuery
                                                   orderby x.filtered.TotalBudget, x.empCounter.Value descending
                                                   select x).AsQueryable();
                                break;
                            case RostEmployeeSortOrder.NormalRate:
                                leastCountQuery = (from x in leastCountQuery
                                                   orderby x.filtered.TotalBudget descending, x.empCounter.Value descending
                                                   select x).AsQueryable();
                                break;
                            case RostEmployeeSortOrder.NormalExperiance:
                                leastCountQuery = (from x in leastCountQuery
                                                   orderby x.filtered.JoiningDate descending, x.filtered.TotalBudget, x.empCounter.Value descending
                                                   select x).AsQueryable();
                                break;
                            case RostEmployeeSortOrder.HighExperiance:
                                leastCountQuery = (from x in leastCountQuery
                                                   orderby x.filtered.JoiningDate, x.filtered.TotalBudget, x.empCounter.Value descending
                                                   select x).AsQueryable();
                                break;
                        }
                        int minvalue = leastCountQuery.Min(x => x.empCounter.Value);
                        var containsDate = rosterPlanList.Where(p2 => p2.PlanDate == sod.reqDate).ToList();
                        var leastCount = leastCountQuery.FirstOrDefault(x => x.empCounter.Value == minvalue && containsDate.All(p2 => p2.EmployeeId != x.filtered.EmployeeId));
                        if (leastCount != null)
                        {
                            int counter = employeeCounter[leastCount.empCounter.Key];
                            if (counter <= shiftOrDepartment.maxCount && !rosterPlanList.Any(x => x.PlanDate == sod.reqDate && x.EmployeeId == leastCount.filtered.EmployeeId))
                            {
                                requiredEmployee++;
                                rosterPlanList.Add(InsertToRosterPlans(solutionId, sod, leastCount.filtered, filterdShiftWeeks, currencyCode, defaultStartTime));
                                employeeCounter[leastCount.empCounter.Key] = counter + 1;
                            }
                        }
                    }
                    else
                        break;
                }
            }
        }

        private List<RosterPlan> AdHocRequirementPlansCreation(Guid solutionId, ShiftOrDepartment shiftOrDepartment, List<EmployeeBudget> filteredEmployeeList,
            List<ShiftWeekSearchOutputModel> filterdShiftWeeks, ref int requiredEmployee, ref Dictionary<Guid, int> employeeCounter, string currencyCode, TimeSpan defaultStartTime)
        {
            List<RosterPlan> rosterPlans = new List<RosterPlan>();
            if (shiftOrDepartment.departmentDetails != null && shiftOrDepartment.departmentDetails.EmployeeSpecifcation.Count() > 0)
            {
                foreach (Guid employeeId in shiftOrDepartment.departmentDetails.EmployeeSpecifcation)
                {
                    EmployeeBudget employeeBudget = filteredEmployeeList.Where(x => x.EmployeeId == employeeId).FirstOrDefault();
                    if (employeeBudget != null)
                    {
                        rosterPlans.Add(InsertToRosterPlans(solutionId, shiftOrDepartment, employeeBudget, filterdShiftWeeks, currencyCode, defaultStartTime));
                        requiredEmployee++;
                        int counter = employeeCounter[employeeBudget.EmployeeId];
                        employeeCounter[employeeBudget.EmployeeId] = ++counter;
                    }
                }
            }
            else if (shiftOrDepartment.shiftDetails != null && shiftOrDepartment.shiftDetails.EmployeeSpecifcation.Count() > 0)
            {
                foreach (Guid employeeId in shiftOrDepartment.shiftDetails.EmployeeSpecifcation)
                {
                    EmployeeBudget employeeBudget = filteredEmployeeList.Where(x => x.EmployeeId == employeeId).FirstOrDefault();
                    if (employeeBudget != null)
                    {
                        rosterPlans.Add(InsertToRosterPlans(solutionId, shiftOrDepartment, employeeBudget, filterdShiftWeeks, currencyCode, defaultStartTime));
                        requiredEmployee++;
                        int counter = employeeCounter[employeeBudget.EmployeeId];
                        employeeCounter[employeeBudget.EmployeeId] = ++counter;
                    }
                }
            }
            if (shiftOrDepartment.adHocDetails != null && shiftOrDepartment.adHocDetails.EmployeeSpecifcation.Count() > 0)
            {
                foreach (Guid employeeId in shiftOrDepartment.adHocDetails.EmployeeSpecifcation)
                {
                    EmployeeBudget employeeBudget = filteredEmployeeList.Where(x => x.EmployeeId == employeeId).FirstOrDefault();
                    if (employeeBudget != null)
                    {
                        rosterPlans.Add(InsertToRosterPlans(solutionId, shiftOrDepartment, employeeBudget, filterdShiftWeeks, currencyCode, defaultStartTime));
                        requiredEmployee++;
                        int counter = employeeCounter[employeeBudget.EmployeeId];
                        employeeCounter[employeeBudget.EmployeeId] = ++counter;
                    }
                }
            }

            return rosterPlans;
        }

        private RosterPlan InsertToRosterPlans(Guid solutionId, ShiftOrDepartment shiftOrDepartment, EmployeeBudget employeeBudget,
            List<ShiftWeekSearchOutputModel> filterdShiftWeeks, string currencyCode, TimeSpan defaultStartTime)
        {
            RosterPlan rosterPlan = new RosterPlan();
            rosterPlan.SolutionId = solutionId;
            rosterPlan.PlanId = Guid.NewGuid();
            rosterPlan.PlanDate = shiftOrDepartment.reqDate;
            rosterPlan.ShiftId = shiftOrDepartment.shiftDetails?.shiftId;
            rosterPlan.ShiftName = shiftOrDepartment.shiftDetails?.shiftName;
            rosterPlan.DepartmentId = shiftOrDepartment.departmentDetails?.DepartmentId != null ? shiftOrDepartment.departmentDetails?.DepartmentId : employeeBudget.DepartmentId;
            rosterPlan.DepartmentName = shiftOrDepartment.departmentDetails?.DepartmentId != null ? shiftOrDepartment.departmentDetails?.DepartmentName : employeeBudget.DepartmentName;
            rosterPlan.EmployeeId = employeeBudget.EmployeeId;
            rosterPlan.EmployeeName = employeeBudget.EmployeeName;
            rosterPlan.EmployeeProfileImage = employeeBudget.EmployeeProfileImage;
            rosterPlan.TotalRate = employeeBudget.TotalBudget;
            rosterPlan.CurrencyCode = currencyCode;
            rosterPlan.FromTime = employeeBudget.FromTime == null ? defaultStartTime : employeeBudget.FromTime;
            rosterPlan.ToTime = employeeBudget.ToTime == null ? rosterPlan.FromTime.Value.Add(new TimeSpan(shiftOrDepartment.maxHours, 0, 0)) : employeeBudget.ToTime;

            if (shiftOrDepartment.adHocDetails != null)
            {
                rosterPlan.FromTime = shiftOrDepartment.adHocDetails.ReqFromTime;
                rosterPlan.ToTime = shiftOrDepartment.adHocDetails.ReqToTime;
            }
            if ((shiftOrDepartment.adHocDetails == null || rosterPlan.FromTime == null) && filterdShiftWeeks.Count > 0)
            {
                ShiftWeekSearchOutputModel shiftWeekSearchOutputModel = filterdShiftWeeks.FirstOrDefault(x => x.DayOfWeek.ToLower() == Enum.GetName(typeof(DayOfWeek), shiftOrDepartment.reqDate.DayOfWeek)?.ToLower());
                rosterPlan.FromTime = shiftWeekSearchOutputModel?.StartTime == null ? defaultStartTime : shiftWeekSearchOutputModel.StartTime;
                rosterPlan.ToTime = shiftWeekSearchOutputModel?.EndTime == null ? defaultStartTime.Add(new TimeSpan(shiftOrDepartment.maxHours, 0, 0)) : shiftWeekSearchOutputModel.EndTime;

                TimeSpan noOfHours = rosterPlan.ToTime.Value.Subtract(rosterPlan.FromTime.Value);
                decimal perHourRate = employeeBudget.BudgetPerHour;
                decimal totalMinutes = (decimal)noOfHours.TotalMinutes - (shiftWeekSearchOutputModel?.AllowedBreakTime == null ? 0 : shiftWeekSearchOutputModel.AllowedBreakTime.Value);
                rosterPlan.TotalRate = employeeBudget.TotalBudget;

                //if (employeeBudget.IsPermanent)
                //{
                //    rosterPlan.TotalRate = employeeBudget.TotalBudget;
                //}
                //else
                //{
                //    rosterPlan.TotalRate = ((totalMinutes / 60) * perHourRate);
                //}
            }
            return rosterPlan;
        }

        public List<RosterEmployeeRatesOutput> GetEmployeeRatesFromRateTags(RosterEmployeeRatesInput rosterEmployeeRatesInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "LoadShiftwiseEmployeeForRoster", "Roster Service"));

            LoggingManager.Debug(rosterEmployeeRatesInput.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertRosterCommandId, rosterEmployeeRatesInput, loggedInContext);
            rosterEmployeeRatesInput.EmployeeIdJson = JsonConvert.SerializeObject(rosterEmployeeRatesInput.EmployeeIds);
            List<RosterEmployeeRatesOutput> employeeRates = _rosterRepository.GetEmployeeRatesFromRateTags(rosterEmployeeRatesInput, loggedInContext, validationMessages);

            return employeeRates;
        }


        public bool SendApproveEmailToManager(RosterPlanInputModel rosterPlanInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, RosterSearchOutputModel rosterSearchOutputModel, string url)
        {
            LoggingManager.Info("Entering into SendReportEmailToManager Method in Reports service");

            var refhtml = _goalRepository.GetHtmlTemplateByName("ManagerEmployeeRosterApproveTemplate", loggedInContext.CompanyGuid);

            List<EmployeeOutputModel> employeeList = _employeeRosterCreation.LoadEmployeeDetails(rosterPlanInputModel.BasicInput.BranchId, loggedInContext, validationMessages);
            if (rosterPlanInputModel.Plans != null && rosterPlanInputModel.Plans.Count > 0)
            {
                decimal budget = rosterPlanInputModel.Plans.Sum(x => (x.TotalRate.HasValue ? x.TotalRate.Value : 0));
                List<Guid> employeeIds = rosterPlanInputModel.Plans.Where(x => x.EmployeeId != null).Select(x => x.EmployeeId.Value).Distinct().ToList();
                StringBuilder htmltable = new StringBuilder();
                foreach (var employeeId in employeeIds)
                {
                    var filteredPlans = rosterPlanInputModel.Plans.Where(x => x.EmployeeId == employeeId).ToList();

                    EmployeeOutputModel employee = employeeList.FirstOrDefault(x => x.EmployeeId == employeeId);
                    if (employee != null)
                    {
                        foreach (var plan in filteredPlans)
                        {
                            htmltable.Append(@"<tr>");
                            htmltable.Append(
                                $"<td class='tabletd'><p>{employee.FirstName + " " + employee.SurName}</p></td > ");
                            htmltable.Append($"<td class='tabletd'><p>{plan.PlanDate:dd-MMM-yyy}</p></td >");
                            htmltable.Append($"<td class='tabletd'><p>{plan.FromTime - TimeSpan.FromMinutes(rosterPlanInputModel.BasicInput.TimeZone)} to {plan.ToTime - TimeSpan.FromMinutes(rosterPlanInputModel.BasicInput.TimeZone)}</p></td >");
                            htmltable.Append($"<td class='tabletd'><p>{(string.IsNullOrEmpty(plan.DepartmentName) ? "Not known" : plan.DepartmentName)}</p></td >");
                            htmltable.Append(@"</tr>");
                        }
                    }
                }
                List<RosterManager> managerDetails = _rosterRepository.GetEmployeeRosterManagers(rosterPlanInputModel.RequestId, loggedInContext, validationMessages);
                if (refhtml != null)
                {
                    var html = refhtml;

                    List<CompanySettingsSearchOutputModel> companyDetails = _masterDataManagementService.GetCompanySettings(new CompanySettingsSearchInputModel(), loggedInContext, validationMessages);

                    var logo = companyDetails.Where(x => x.Key == "MainLogo").FirstOrDefault().Value;

                    if (managerDetails != null && managerDetails.Count > 0)
                    {
                        Models.User.UserSearchCriteriaInputModel userSearchModel = new Models.User.UserSearchCriteriaInputModel();
                        userSearchModel.CompanyId = loggedInContext.CompanyGuid;
                        userSearchModel.UserId = loggedInContext.LoggedInUserId;

                        List<UserOutputModel> userDetails = _userService.GetAllUsers(userSearchModel, loggedInContext, validationMessages);
                        html = html.Replace("##EmployeeRoster##", htmltable.ToString());
                        html = html.Replace("##Budget##", budget.ToString());
                        html = html.Replace("##EmployeeName##", userDetails[0].FullName);
                        html = html.Replace("##RequestLink##", string.Concat(url, "/manageroster/updateroster?id=", rosterPlanInputModel.RequestId));
                        html = html.Replace("##logoSrc##", logo.ToString());
                        List<string> toMails = new List<string>();
                        foreach (var manager in managerDetails)
                        {
                            toMails.Add(manager.Email);

                            _notificationService.SendNotification(new RosterNotifications(
                                  NotificationSummaryConstants.RosterSubmitForApproval,
                                  loggedInContext.LoggedInUserId,
                                  manager.UserId,
                                  "Roster creation",
                                  "New message from Snovasys Business Suite"
                                  ), loggedInContext, manager.UserId);
                        }
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpMail = null,
                            SmtpPassword = null,
                            ToAddresses = toMails.ToArray(),
                            HtmlContent = html,
                            Subject = "Snovasys Business Suite: Roster plan approval",
                            CCMails = null,
                            BCCMails = null,
                            MailAttachments = null,
                            IsPdf = null
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                    }
                }
            }
            return true;
        }

        public bool SendRosterMailsToManagerAndEmployeeAfterApproval(RosterPlanInputModel rosterPlanInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, RosterSearchOutputModel rosterSearchOutputModel)
        {
            try
            {
                SendReportEmailToEmployee(rosterPlanInputModel, loggedInContext, validationMessages, rosterSearchOutputModel);
                SendReportEmailToManager(rosterPlanInputModel, loggedInContext, validationMessages, rosterSearchOutputModel);
                return true;
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendRosterMailsToManagerAndEmployeeAfterApproval", "RosterService ", ex.Message), ex);

                return false;
            }
        }

        public bool SendReportEmailToEmployee(RosterPlanInputModel rosterPlanInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, RosterSearchOutputModel rosterSearchOutputModel)
        {
            LoggingManager.Info("Entering into SendReportEmail Method in Reports service");

            var html = _goalRepository.GetHtmlTemplateByName("EmployeeRosterTemplate", loggedInContext.CompanyGuid);
            if (html != null && rosterSearchOutputModel != null)
            {
                List<CompanySettingsSearchOutputModel> companyDetails = _masterDataManagementService.GetCompanySettings(new CompanySettingsSearchInputModel(), loggedInContext, validationMessages);

                var logo = companyDetails.Where(x => x.Key == "MainLogo").FirstOrDefault().Value;

                List<EmployeeOutputModel> employeeList = _employeeRosterCreation.LoadEmployeeDetails(rosterPlanInputModel.BasicInput.BranchId, loggedInContext, validationMessages);

                List<Guid> employeeIds = rosterPlanInputModel.Plans.Where(x => x.EmployeeId != null).Select(x => x.EmployeeId.Value).Distinct().ToList();

                foreach (var employeeId in employeeIds)
                {
                    var empHtml = html;
                    var filteredPlans = rosterPlanInputModel.Plans.Where(x => x.EmployeeId == employeeId).ToList();
                    StringBuilder htmltable = new StringBuilder();
                    EmployeeOutputModel employee = employeeList.FirstOrDefault(x => x.EmployeeId == employeeId);
                    if (employee != null)
                    {
                        foreach (var plan in filteredPlans)
                        {
                            string notKnown = "Not known";
                            htmltable.Append(@"<tr>");
                            htmltable.Append(
                                $"<td class='tabletd'><p>{employee.FirstName + " " + employee.SurName}</p></td > ");
                            htmltable.Append($"<td class='tabletd'><p>{plan.PlanDate:dd-MMM-yyy}</p></td >");
                            htmltable.Append($"<td class='tabletd'><p>{plan.FromTime - TimeSpan.FromMinutes(rosterPlanInputModel.BasicInput.TimeZone)} to {plan.ToTime - TimeSpan.FromMinutes(rosterPlanInputModel.BasicInput.TimeZone)}</p></td >");
                            htmltable.Append($"<td class='tabletd'><p>{(string.IsNullOrEmpty(plan.DepartmentName) ? notKnown : plan.DepartmentName)}</p></td >");
                            htmltable.Append(@"</tr>");
                        }

                        empHtml = empHtml.Replace("##EmployeeName##", rosterSearchOutputModel.CreatedByUserName);
                        empHtml = empHtml.Replace("##EmployeeRoster##", htmltable.ToString());
                        empHtml = empHtml.Replace("##logoSrc##", logo.ToString());
                        if (employee.Email != null)
                        {
                            var toMails = employee.Email.Split('\n');
                            EmailGenericModel emailModel = new EmailGenericModel
                            {
                                SmtpMail = null,
                                SmtpPassword = null,
                                ToAddresses = toMails,
                                HtmlContent = empHtml,
                                //Subject = "Snovasys Business Suite: Employee Roster Template",
                                Subject = "Snovasys Business Suite: Roster Plan",
                                CCMails = null,
                                BCCMails = null,
                                MailAttachments = null,
                                IsPdf = null
                            };
                            _emailService.SendMail(loggedInContext, emailModel);
                            LoggingManager.Info("sent reports Pdf to " + employee.Email +
                                                " in SendReportEmail in Reports Service");
                        }
                    }
                }
            }
            return true;
        }

        public bool SendReportEmailToManager(RosterPlanInputModel rosterPlanInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, RosterSearchOutputModel rosterSearchOutputModel)
        {
            LoggingManager.Info("Entering into SendReportEmailToManager Method in Reports service");
            //SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

            var refhtml = _goalRepository.GetHtmlTemplateByName("ManagerEmployeeRosterTemplate", loggedInContext.CompanyGuid);
            if (refhtml != null)
            {
                List<CompanySettingsSearchOutputModel> companyDetails = _masterDataManagementService.GetCompanySettings(new CompanySettingsSearchInputModel(), loggedInContext, validationMessages);

                var logo = companyDetails.Where(x => x.Key == "MainLogo").FirstOrDefault().Value;

                List<EmployeeOutputModel> employeeList = _employeeRosterCreation.LoadEmployeeDetails(rosterPlanInputModel.BasicInput.BranchId, loggedInContext, validationMessages);

                decimal budget = rosterPlanInputModel.Plans.Sum(x => (x.TotalRate.HasValue ? x.TotalRate.Value : 0));
                List<Guid> employeeIds = rosterPlanInputModel.Plans.Where(x => x.EmployeeId != null).Select(x => x.EmployeeId.Value).Distinct().ToList();
                StringBuilder htmltable = new StringBuilder();
                foreach (var employeeId in employeeIds)
                {
                    var filteredPlans = rosterPlanInputModel.Plans.Where(x => x.EmployeeId == employeeId).ToList();

                    EmployeeOutputModel employee = employeeList.FirstOrDefault(x => x.EmployeeId == employeeId);
                    if (employee != null)
                    {
                        foreach (var plan in filteredPlans)
                        {
                            htmltable.Append(@"<tr>");
                            htmltable.Append(
                                $"<td class='tabletd'><p>{employee.FirstName + " " + employee.SurName}</p></td > ");
                            htmltable.Append($"<td class='tabletd'><p>{plan.PlanDate:dd-MMM-yyy}</p></td >");
                            htmltable.Append($"<td class='tabletd'><p>{plan.FromTime - TimeSpan.FromMinutes(rosterPlanInputModel.BasicInput.TimeZone)} to {plan.ToTime - TimeSpan.FromMinutes(rosterPlanInputModel.BasicInput.TimeZone)}</p></td >");
                            htmltable.Append($"<td class='tabletd'><p>{(string.IsNullOrEmpty(plan.DepartmentName) ? "Not known" : plan.DepartmentName)}</p></td >");
                            htmltable.Append(@"</tr>");
                        }
                    }
                }
                List<RosterManager> managerDetails = _rosterRepository.GetEmployeeRosterManagers(rosterPlanInputModel.RequestId, loggedInContext, validationMessages);

                Models.User.UserSearchCriteriaInputModel userSearchModel = new Models.User.UserSearchCriteriaInputModel();
                userSearchModel.CompanyId = loggedInContext.CompanyGuid;
                userSearchModel.UserId = loggedInContext.LoggedInUserId;

                var userDetails = _userService.GetAllUsers(userSearchModel, loggedInContext, validationMessages);

                if (managerDetails != null && managerDetails.Count > 0)
                {
                    var html = refhtml;
                    foreach (var manager in managerDetails)
                    {
                        html = html.Replace("##Budget##", budget.ToString());
                        html = html.Replace("##EmployeeRoster##", htmltable.ToString());
                        html = html.Replace("##EmployeeName##", userDetails[0].FullName);
                        html = html.Replace("##logoSrc##", logo.ToString());

                        List<string> toMails = new List<string>();
                        toMails.Add(manager.Email);
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpMail = null,
                            SmtpPassword = null,
                            ToAddresses = toMails.ToArray(),
                            HtmlContent = html,
                            Subject = "Snovasys Business Suite: Roster Report",
                            CCMails = null,
                            BCCMails = null,
                            MailAttachments = null,
                            IsPdf = null
                        };
                        _emailService.SendMail(loggedInContext, emailModel);

                        _notificationService.SendNotification(new RosterNotifications(
                              NotificationSummaryConstants.RosterApproved,
                              loggedInContext.LoggedInUserId,
                              manager.UserId,
                              "Approved roster",
                              "New message from Snovasys Business Suite"
                              ), loggedInContext, manager.UserId);
                    }
                }
            }
            return true;
        }

        public bool SendTimesheetEmailToManagerForApproval(TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel, List<UserOutputModel> userDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entering into SendTimesheetEmailToEmployeeAfterRejection Method in Reports service");
            //SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

            var html = _goalRepository.GetHtmlTemplateByName("EmployeeRosterTimesheetSubmissionTemplate", loggedInContext.CompanyGuid);

            Models.User.UserSearchCriteriaInputModel userSearchModel = new Models.User.UserSearchCriteriaInputModel();
            userSearchModel.CompanyId = loggedInContext.CompanyGuid;
            userSearchModel.UserId = timeSheetPunchCardUpDateInputModel.ApproverId;

            userDetails = _userService.GetAllUsers(userSearchModel, loggedInContext, validationMessages);

            userSearchModel = new Models.User.UserSearchCriteriaInputModel();
            userSearchModel.CompanyId = loggedInContext.CompanyGuid;
            userSearchModel.UserId = loggedInContext.LoggedInUserId;

            var reqby = _userService.GetAllUsers(userSearchModel, loggedInContext, validationMessages);

            List<CompanySettingsSearchOutputModel> companyDetails = _masterDataManagementService.GetCompanySettings(new CompanySettingsSearchInputModel(), loggedInContext, validationMessages);

            var logo = companyDetails.Where(x => x.Key == "MainLogo").FirstOrDefault().Value;

            if (userDetails != null && userDetails.Count > 0)
            {
                html = html.Replace("##FromDate##", timeSheetPunchCardUpDateInputModel.FromDate.Value.ToString("dd MMM yyyy"));
                html = html.Replace("##ToDate##", timeSheetPunchCardUpDateInputModel.ToDate.Value.ToString("dd MMM yyyy"));
                html = html.Replace("##EmployeeName##", reqby[0].FullName);
                html = html.Replace("##logoSrc##", logo.ToString());

                List<string> toMails = new List<string>();
                toMails.Add(userDetails[0].Email);
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpMail = null,
                    SmtpPassword = null,
                    ToAddresses = toMails.ToArray(),
                    HtmlContent = html,
                    Subject = "Snovasys Business Suite: Employee roster timesheet submitted",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
            return true;
        }

        public bool SendTimesheetEmailToEmployeeAfterRejection(TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel, List<UserOutputModel> userDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entering into SendTimesheetEmailToEmployeeAfterRejection Method in Reports service");

            var html = _goalRepository.GetHtmlTemplateByName("EmployeeRosterTimesheetAfterRejectionTemplate", loggedInContext.CompanyGuid);

            List<CompanySettingsSearchOutputModel> companyDetails = _masterDataManagementService.GetCompanySettings(new CompanySettingsSearchInputModel(), loggedInContext, validationMessages);

            var logo = companyDetails.Where(x => x.Key == "MainLogo").FirstOrDefault().Value;

            if (userDetails != null && userDetails.Count > 0)
            {
                html = html.Replace("##FromDate##", timeSheetPunchCardUpDateInputModel.FromDate.Value.ToString("dd MMM yyyy"));
                html = html.Replace("##ToDate##", timeSheetPunchCardUpDateInputModel.ToDate.Value.ToString("dd MMM yyyy"));
                html = html.Replace("##EmployeeName##", userDetails[0].FullName);
                html = html.Replace("##Reason##", timeSheetPunchCardUpDateInputModel.RejectedReason);
                html = html.Replace("##logoSrc##", logo.ToString());

                List<string> toMails = new List<string>();
                toMails.Add(userDetails[0].Email);
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpMail = null,
                    SmtpPassword = null,
                    ToAddresses = toMails.ToArray(),
                    HtmlContent = html,
                    Subject = "Snovasys Business Suite: Employee roster timesheet rejected",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
            return true;
        }

        public bool SendTimesheetEmailToEmployeeAfterApproval(TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel, List<UserOutputModel> userDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entering into SendEmailToEmployeeAfterApproval Method in Reports service");
            //SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

            var html = _goalRepository.GetHtmlTemplateByName("EmployeeRosterDayWiseAmountAfterApproveTemplate", loggedInContext.CompanyGuid);

            List<EmployeeTimesheetRate> employeeTimesheetRates = _rosterRepository.GetEmployeeUponTimesheetApproval(timeSheetPunchCardUpDateInputModel, loggedInContext, validationMessages);
            List<CompanySettingsSearchOutputModel> companyDetails = _masterDataManagementService.GetCompanySettings(new CompanySettingsSearchInputModel(), loggedInContext, validationMessages);

            var logo = companyDetails.Where(x => x.Key == "MainLogo").FirstOrDefault().Value;

            if (employeeTimesheetRates != null && employeeTimesheetRates.Count > 0)
            {
                StringBuilder htmltable = new StringBuilder();
                foreach (var employeeDetails in employeeTimesheetRates)
                {
                    htmltable.Append(@"<tr>");
                    htmltable.Append(
                        $"<td class='tabletd'><p>{employeeDetails.LogDate.ToString("dd MMM yyyy")}</p></td > ");
                    htmltable.Append($"<td class='tabletd'><p>{ Math.Round(Convert.ToDecimal(employeeDetails.TotalMinutesWorked) / 60, 2) }</p></td >");
                    htmltable.Append($"<td class='tabletd'><p>{ employeeDetails.Breakmins}</p></td >");
                    htmltable.Append($"<td class='tabletd'><p>{ employeeDetails.CurrencyCode + " " + employeeDetails.ActualRate.ToString("0.##")}</p></td >");
                    htmltable.Append(@"</tr>");
                }
                html = html.Replace("##ListOfApprovedDates##", htmltable.ToString());
                html = html.Replace("##EmployeeName##", employeeTimesheetRates[0].EmployeeName);
                html = html.Replace("##logoSrc##", logo.ToString());

                List<string> toMails = new List<string>();
                toMails.Add(employeeTimesheetRates[0].Email);
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpMail = null,
                    SmtpPassword = null,
                    ToAddresses = toMails.ToArray(),
                    HtmlContent = html,
                    Subject = "Snovasys Business Suite: Employee roster timesheet approved",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
            return true;
        }

        public bool? SendTimesheetEmployeeManagerMails(string statusName, TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel,
            List<UserOutputModel> userDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendFinalReports", "Roster Service"));
                List<Guid> requestIds = new List<Guid>();
                if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
                {
                    return null;
                }
                if (statusName == "Approved")
                {
                    requestIds = _rosterRepository.CheckForPlanApprovalCompletion(timeSheetPunchCardUpDateInputModel, loggedInContext, validationMessages);
                    SendTimesheetEmailToEmployeeAfterApproval(timeSheetPunchCardUpDateInputModel, userDetails, loggedInContext, validationMessages);
                }
                else if (statusName == "Rejected")
                {
                    SendTimesheetEmailToEmployeeAfterRejection(timeSheetPunchCardUpDateInputModel, userDetails, loggedInContext, validationMessages);
                }
                else
                {
                    SendTimesheetEmailToManagerForApproval(timeSheetPunchCardUpDateInputModel, userDetails, loggedInContext, validationMessages);
                }

                LoggingManager.Info("Entering into SendFinalReports in Reports service");

                if (requestIds != null && requestIds.Count > 0)
                {
                    SendMailsToManagersEmployees(requestIds, "manager", loggedInContext, validationMessages);
                    SendMailsToManagersEmployees(requestIds, "employee", loggedInContext, validationMessages);
                }
                return true;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendTimesheetEmployeeManagerMails", "RosterService ",exception.Message), exception);

                return null;
            }
        }

        public bool? SendFinishMailToEmployee(TimeSheetManagementInputModel timeSheetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entering into SendReportEmailToManager Method in Reports service");

            var html = _goalRepository.GetHtmlTemplateByName("EmployeeRosterDayFinishTemplate", loggedInContext.CompanyGuid);

            EmployeeTimesheetRate employeeTimesheetRate = _rosterRepository.GetEmployeeRatesUponTimesheetDayFinish(timeSheetModel, loggedInContext, validationMessages).FirstOrDefault();
            List<CompanySettingsSearchOutputModel> companyDetails = _masterDataManagementService.GetCompanySettings(new CompanySettingsSearchInputModel(), loggedInContext, validationMessages);

            var logo = companyDetails != null ? companyDetails.Where(x => x.Key == "MainLogo").FirstOrDefault().Value : "";

            if (employeeTimesheetRate != null)
            {
                html = html.Replace("##TimeLogged##", employeeTimesheetRate.TotalMinutesWorked.ToString());
                html = html.Replace("##EmployeeName##", employeeTimesheetRate.EmployeeName);
                html = html.Replace("##BreakMinutes##", employeeTimesheetRate.Breakmins.ToString());
                html = html.Replace("##ActualRate##", employeeTimesheetRate.CurrencyCode + " " + employeeTimesheetRate.ActualRate.ToString("0.##"));
                html = html.Replace("##Date##", timeSheetModel.Date.HasValue ? timeSheetModel.Date.Value.ToString("dd MMM yyyy") : DateTime.Now.ToString("dd MMM yyyy"));
                html = html.Replace("##logoSrc##", logo.ToString());
                List<string> toMails = new List<string>();
                if (employeeTimesheetRate.Email != null)
                {
                    toMails.Add(employeeTimesheetRate.Email);
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpMail = null,
                        SmtpPassword = null,
                        ToAddresses = toMails.ToArray(),
                        HtmlContent = html,
                        Subject = "Snovasys Business Suite: Employee Timesheet Submission",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);

                    _notificationService.SendNotification(new RosterNotifications(
                              string.Format(NotificationSummaryConstants.EmployeeSubmittedTimesheetForDay, timeSheetModel.Date.HasValue ? timeSheetModel.Date.Value.ToString("dd MMM yyyy") : DateTime.Now.ToString("dd MMM yyyy")),
                              loggedInContext.LoggedInUserId,
                              employeeTimesheetRate.UserId,
                              "Roster day finish status",
                              "New message from Snovasys Business Suite"
                              ), loggedInContext, employeeTimesheetRate.UserId);
                }
            }
            return true;
        }

        public void SendMailsToManagersEmployees(List<Guid> requestIds, string mailToType, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<RosterCompletionReport> allRosterCompletionReports = new List<RosterCompletionReport>();

            foreach (Guid requestId in requestIds)
            {
                List<RosterCompletionReport> rosterCompletionReports;

                if (mailToType == "manager")
                    rosterCompletionReports = _rosterRepository.GetRosterComparisionManagerReport(requestId, loggedInContext, validationMessages);
                else
                    rosterCompletionReports = _rosterRepository.GetEmployeeRosterFinalReport(requestId, loggedInContext, validationMessages);
                allRosterCompletionReports.AddRange(rosterCompletionReports);
            }
            string refHtml;
            if (mailToType == "manager")
            {
                refHtml = _goalRepository.GetHtmlTemplateByName("ManagerRosterCompletionReport", loggedInContext.CompanyGuid);
            }
            else
            {
                refHtml = _goalRepository.GetHtmlTemplateByName("EmployeeRosterCompletionReport", loggedInContext.CompanyGuid);
            }
            List<CompanySettingsSearchOutputModel> companyDetails = _masterDataManagementService.GetCompanySettings(new CompanySettingsSearchInputModel(), loggedInContext, validationMessages);

            var logo = companyDetails.Where(x => x.Key == "MainLogo").FirstOrDefault().Value;
            foreach (RosterCompletionReport rosterCompletionReport in allRosterCompletionReports)
            {
                string html = refHtml;
                if (html != null && rosterCompletionReport.UserName != null)
                {
                    html = html.Replace("##EmployeeName##", rosterCompletionReport.EmployeeName);
                    html = html.Replace("##FromDate##", rosterCompletionReport.RequiredFromDate.ToString("dd MMM yyyy"));
                    html = html.Replace("##ToDate##", rosterCompletionReport.RequiredToDate.ToString("dd MMM yyyy"));
                    html = html.Replace("##PlannedRate##", rosterCompletionReport.PlannedRate.ToString());
                    html = html.Replace("##ActualRate##", rosterCompletionReport.ActualRate.ToString("0.##"));
                    if (mailToType == "manager")
                    {
                        html = html.Replace("##PlannedEmployee##", rosterCompletionReport.PlannedEmployeeId.ToString());
                        html = html.Replace("##ActualEmployee##", rosterCompletionReport.ActualEmployeeId.ToString());
                    }
                    html = html.Replace("##logoSrc##", logo.ToString());

                    var toAddresses = new string[] { rosterCompletionReport.UserName };
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpMail = null,
                        SmtpPassword = null,
                        ToAddresses = toAddresses,
                        HtmlContent = html,
                        Subject = "Snovasys Business Suite: Roster Completion Report",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);

                    //_notificationService.SendNotification(new RosterNotifications(
                    //          string.Format(NotificationSummaryConstants.RosterCompletionReport, rosterCompletionReport.RequiredFromDate.ToString("dd MMM yyyy"), rosterCompletionReport.RequiredToDate.ToString("dd MMM yyyy"), rosterCompletionReport.ActualRate.ToString("0.##")),
                    //          loggedInContext.LoggedInUserId,
                    //          rosterCompletionReport.UserId,
                    //          "Roster completion status",
                    //          "New message from Snovasys Business Suite"
                    //          ), loggedInContext, rosterCompletionReport.UserId);
                }
            }
        }

        public void SendPushNotification(RosterPlanInputModel rosterPlanInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                List<EmployeeOutputModel> employeeList = _employeeRosterCreation.LoadEmployeeDetails(rosterPlanInputModel.BasicInput.BranchId, loggedInContext, validationMessages);

                List<Guid> employeeIds = rosterPlanInputModel.Plans.Select(x => x.EmployeeId.Value).Distinct().ToList();

                foreach (var employeeId in employeeIds)
                {
                    EmployeeOutputModel employee = employeeList.FirstOrDefault(x => x.EmployeeId == employeeId);
                    if (employee != null)
                    {
                        string rosterName = rosterPlanInputModel?.BasicInput.RostName;

                        if (string.IsNullOrEmpty(rosterPlanInputModel?.BasicInput.RostName))
                        {
                            var rosterdetails = GetRosterPlans(new RosterSearchInputModel() { RequestId = rosterPlanInputModel.RequestId, PageNumber = 0, PageSize = 1 }, loggedInContext, validationMessages);
                            rosterName = rosterdetails?.Count > 0 ? "- " + rosterdetails?[0].RequestName : string.Empty;
                        }
                        _notificationService.SendNotification(new RosterNotifications(
                              string.Format(NotificationSummaryConstants.RosterApproveNotification, rosterName),
                              loggedInContext.LoggedInUserId,
                              employee.UserId,
                              "Roster status",
                              "New message from Snovasys Business Suite"
                              ), loggedInContext, employee.UserId);
                    }
                }

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendPushNotification", "RosterService ", exception.Message), exception);

            }
        }

    }
}
