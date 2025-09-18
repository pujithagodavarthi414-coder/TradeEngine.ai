using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Models.Roster;
using Btrak.Models.TimeSheet;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Dapper.Dal.Partial
{
    public partial class RosterRepository : BaseRepository
    {
        public Guid? CreateRosterPlan(RosterPlanInputModel rosterPlanInputModel, string plans, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RequestId", rosterPlanInputModel.RequestId);
                    vParams.Add("@RosterPlans", plans);
                    vParams.Add("@StartDate", rosterPlanInputModel.BasicInput.StartDate);
                    vParams.Add("@EndDate", rosterPlanInputModel.BasicInput.EndDate);
                    vParams.Add("@BranchId", rosterPlanInputModel.BasicInput.BranchId);
                    vParams.Add("@IsApprove", rosterPlanInputModel.BasicInput.IsApprove);
                    vParams.Add("@IsTemplate", rosterPlanInputModel.BasicInput.IsTemplate);
                    vParams.Add("@IsSubmitted", rosterPlanInputModel.BasicInput.IsSubmitted);
                    vParams.Add("@RostName", rosterPlanInputModel.BasicInput.RostName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", rosterPlanInputModel.BasicInput.IsArchived);
                    vParams.Add("@BreakMins", rosterPlanInputModel.BasicInput.Breakmins);
                    vParams.Add("@Budget", rosterPlanInputModel.BasicInput.Budget);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRosterPlan, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateRosterPlan", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCreateRosterPlan);
                return new Guid();
            }
        }

        public Guid? CreateRosterRequest(RosterInputModel rosterInputModel, string basicInfo, string solutions, string plans, string shiftDetails, string departmentDetails, string adHocDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RosterRequest", basicInfo);
                    vParams.Add("@RosterSolutions", solutions);
                    vParams.Add("@RosterPlans", plans);
                    vParams.Add("@RosterShift", shiftDetails);
                    vParams.Add("@RosterDepartment", departmentDetails);
                    vParams.Add("@RosterAdHoc", adHocDetails);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRosterRequest, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateRosterRequest", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCreateRosterSolutions);
                return new Guid();
            }
        }

        public List<RosterSearchOutputModel> GetRosterPlans(RosterSearchInputModel rosterSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RequestId", rosterSearchInputModel.RequestId);
                    vParams.Add("@IsTemplate", rosterSearchInputModel.IsTemplate);
                    vParams.Add("@SearchText", rosterSearchInputModel.SearchText?.Replace("\\", ""));
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageSize", rosterSearchInputModel.PageSize);
                    vParams.Add("@PageNumber", rosterSearchInputModel.PageNumber);
                    vParams.Add("@SortBy", rosterSearchInputModel.OrderByField);
                    vParams.Add("@SortDirection", rosterSearchInputModel.OrderByDirection.HasValue ? (rosterSearchInputModel.OrderByDirection.Value ? "asc" : "desc") : "desc");
                    vParams.Add("@IsArchived", rosterSearchInputModel.IsArchived);
                    vParams.Add("@BranchId", rosterSearchInputModel.BranchId);
                    return vConn.Query<RosterSearchOutputModel>(StoredProcedureConstants.SpGetRosterPlans, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRosterPlans", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetRosterPlans);
                return new List<RosterSearchOutputModel>();
            }
        }

        public List<RosterPlanOutputModel> GetRosterPlanByRequest(RosterSearchInputModel rosterSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RequestId", rosterSearchInputModel.RequestId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RosterPlanOutputModel>(StoredProcedureConstants.SpGetRosterPlanByRequest, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRosterPlanByRequest", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetRosterPlanByRequest);
                return new List<RosterPlanOutputModel>();
            }
        }

        public RosterPlanSolutionOutput GetRosterSolutionsById(RosterInputModel rosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RequestId", rosterInputModel.RequestId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    var retunModels = vConn.QueryMultiple(StoredProcedureConstants.SpGetRosterSolutionsById, vParams, commandType: CommandType.StoredProcedure);
                    // solutions
                    List<RosterSolution> rosterSolutions = retunModels.Read<RosterSolution>().ToList();
                    List<RosterPlan> rosterPlans = retunModels.Read<RosterPlan>().ToList();

                    List<RosterPlanSolution> rosterPlanSolutions = new List<RosterPlanSolution>();
                    RosterPlanSolution rosterPlanSolution;
                    foreach (RosterSolution rosterSolution in rosterSolutions)
                    {
                        rosterPlanSolution = new RosterPlanSolution();
                        rosterPlanSolution.RequestId = rosterInputModel.RequestId.Value;
                        rosterPlanSolution.Solution = rosterSolution;
                        rosterPlanSolution.Plans = rosterPlans.Where(x => x.SolutionId == rosterSolution.SolutionId).ToList();
                        rosterPlanSolutions.Add(rosterPlanSolution);
                    }

                    RosterPlanSolutionOutput rosterPlanSolutionOutput = new RosterPlanSolutionOutput();
                    rosterPlanSolutionOutput.rosterBasicDetails = retunModels.Read<RosterBasicDetails>().FirstOrDefault();
                    rosterPlanSolutionOutput.rosterPlanSolutions = rosterPlanSolutions;
                    return rosterPlanSolutionOutput;

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRosterSolutionsById", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetRosterPlanByRequest);
                return new RosterPlanSolutionOutput();
            }
        }

        public Guid? CheckRosterName(RosterInputModel rosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RequestId", rosterInputModel.RequestId);
                    vParams.Add("@RosterName", rosterInputModel.rosterBasicDetails.RostName);
                    vParams.Add("@RostEmployeeId", rosterInputModel.rosterBasicDetails.RostEmployeeId);
                    vParams.Add("@RostFromDate", rosterInputModel.rosterBasicDetails.RostStartDate <= DateTime.MinValue ? (DateTime?)null : rosterInputModel.rosterBasicDetails.RostStartDate);
                    vParams.Add("@RostToDate", rosterInputModel.rosterBasicDetails.RostEndDate <= DateTime.MinValue ? (DateTime?)null : rosterInputModel.rosterBasicDetails.RostEndDate);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpCheckRosterName, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckRosterName", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCheckRosterName);
                return new Guid();
            }
        }

        public List<RosterTemplatePlanOutputModel> GetRosterTemplatePlanByRequest(RosterSearchInputModel rosterSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())  
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RequestId", rosterSearchInputModel.RequestId);
                    vParams.Add("@StartDate", rosterSearchInputModel.StartDate.HasValue ? rosterSearchInputModel.StartDate : DateTime.UtcNow );
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RosterTemplatePlanOutputModel>(StoredProcedureConstants.SpGetRosterTemplatePlanByRequest, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRosterTemplatePlanByRequest", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetRosterTemplatePlanByRequest);
                return new List<RosterTemplatePlanOutputModel>();
            }
        }

        public List<EmployeeTimesheetRate> GetEmployeeUponTimesheetApproval(TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", timeSheetPunchCardUpDateInputModel.UserId);
                    vParams.Add("@FromDate", timeSheetPunchCardUpDateInputModel.FromDate);
                    vParams.Add("@Todate", timeSheetPunchCardUpDateInputModel.ToDate);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeTimesheetRate>(StoredProcedureConstants.SpGetEmployeeUponTimesheetApproval, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeUponTimesheetApproval", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeUponTimesheetApproval);
                return new List<EmployeeTimesheetRate>();
            }
        }

        public List<Guid> GetApprovedRosterRequests(TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", timeSheetPunchCardUpDateInputModel.UserId);
                    vParams.Add("@ApprovedDate", timeSheetPunchCardUpDateInputModel.FromDate);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpGetApprovedRosterRequests, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetApprovedRosterRequests", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetApprovedRosterRequests);
                return new List<Guid>();
            }
        }

        public List<RosterCompletionReport> GetRosterComparisionManagerReport(Guid requestId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RequestId", requestId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RosterCompletionReport>(StoredProcedureConstants.SpGetRosterComparisionManagerReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRosterComparisionManagerReport", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionComparisionManagerReport);
                return new List<RosterCompletionReport>();
            }
        }

        public List<RosterCompletionReport> GetEmployeeRosterFinalReport(Guid requestId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RequestId", requestId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RosterCompletionReport>(StoredProcedureConstants.SpGetEmployeeRosterFinalReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeRosterFinalReport", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeRosterFinalReport);
                return new List<RosterCompletionReport>();
            }
        }

        public List<RosterEmployeeLeave> GetEmployeeRosterLeaveDates(RosterBasicDetails rosterBasicDetails, string EmployeeJson, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FromDate", rosterBasicDetails.RostStartDate);
                    vParams.Add("@ToDate", rosterBasicDetails.RostEndDate);
                    vParams.Add("@EmployeeJson", EmployeeJson);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RosterEmployeeLeave>(StoredProcedureConstants.SpGetRosterEmployeeOnleave, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeRosterLeaveDates", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeRosterLeaveDates);
                return new List<RosterEmployeeLeave>();
            }
        }

        public List<RosterEmployeeUnavailability> GetEmployeeRosterUnavailability(RosterBasicDetails rosterBasicDetails, string EmployeeJson, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FromDate", rosterBasicDetails.RostStartDate);
                    vParams.Add("@ToDate", rosterBasicDetails.RostEndDate);
                    vParams.Add("@EmployeeJson", EmployeeJson);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RosterEmployeeUnavailability>(StoredProcedureConstants.SpGetEmployeeRosterUnavailability, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeRosterUnavailability", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeRosterUnavailability);
                return new List<RosterEmployeeUnavailability>();
            }
        }

        public List<RosterManager> GetEmployeeRosterManagers(Guid requestId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RequestId", requestId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RosterManager>(StoredProcedureConstants.SpGetRosterManagers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeRosterManagers", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeRosterManagers);
                return new List<RosterManager>();
            }
        }

        public List<RosterPlan> LoadShiftwiseEmployeeForRoster(ShiftWiseEmployeeRosterInputModel shiftWiseEmployeeRosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@StartDate", shiftWiseEmployeeRosterInputModel.StartDate);
                    vParams.Add("@EndDate", shiftWiseEmployeeRosterInputModel.EndDate);
                    vParams.Add("@IncludeHolidays", shiftWiseEmployeeRosterInputModel.Includeholidays);
                    vParams.Add("@IncludeWeekends", shiftWiseEmployeeRosterInputModel.IncludeWeekends);
                    vParams.Add("@ShiftIds", shiftWiseEmployeeRosterInputModel.ShiftString);
                    vParams.Add("@BranchId", shiftWiseEmployeeRosterInputModel.BranchId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RosterPlan>(StoredProcedureConstants.SpGetShiftwiseEmployeeRoster, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "LoadShiftwiseEmployeeForRoster", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionLoadShiftwiseEmployeeForRoster);
                return new List<RosterPlan>();
            }
        }

        public List<EmployeeTimesheetRate> GetEmployeeRatesUponTimesheetDayFinish(TimeSheetManagementInputModel timeSheetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", timeSheetModel.UserId);
                    vParams.Add("@DateOfSubmission", timeSheetModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeTimesheetRate>(StoredProcedureConstants.SpGetRosterEmployeeActualRateOnTimesheet, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeRatesUponTimesheetDayFinish", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeUponTimesheetApproval);
                return new List<EmployeeTimesheetRate>();
            }
        }

        public List<RosterEmployeeRatesOutput> GetEmployeeRatesFromRateTags(RosterEmployeeRatesInput rosterEmployeeRatesInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CreationDate", rosterEmployeeRatesInput.CreatedDate);
                    vParams.Add("@StartTime", rosterEmployeeRatesInput.StartTime);
                    vParams.Add("@EndTime", rosterEmployeeRatesInput.EndTime);
                    vParams.Add("@EmployeeIds", rosterEmployeeRatesInput.EmployeeIdJson);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RosterEmployeeRatesOutput>(StoredProcedureConstants.SpGetEmployeeRosterRates, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeRatesFromRateTags", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeUponTimesheetApproval);
                return new List<RosterEmployeeRatesOutput>();
            }
        }

        public List<Guid> CheckForPlanApprovalCompletion(TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", timeSheetPunchCardUpDateInputModel.UserId);
                    vParams.Add("@FromDate", timeSheetPunchCardUpDateInputModel.FromDate);
                    vParams.Add("@ToDate", timeSheetPunchCardUpDateInputModel.ToDate);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpdateRosterRequestOnTimesheetApproval, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckForPlanApprovalCompletion", "RosterRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeUponTimesheetApproval);
                return new List<Guid>();
            }
        }
    }
}
