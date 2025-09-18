using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.Repositories;

namespace Btrak.Services.OrgChart
{
    public class OrgChartService : IOrgChartService
    {
        private readonly DesignationRepository _designationRepository;
        private readonly UserRepository _userRepository;
        private readonly EmployeeDesignationRepository _employeeDesignationRepository;
        private readonly EmployeeRepository _employeeRepository;
        private readonly EmployeeReportToRepository _employeeReportToRepository;
        private readonly RoleRepository _roleRepository;
        public OrgChartService()
        {
            _designationRepository = new DesignationRepository();
            _userRepository = new UserRepository();
            _employeeDesignationRepository = new EmployeeDesignationRepository();
            _employeeRepository = new EmployeeRepository();
            _employeeReportToRepository = new EmployeeReportToRepository();
            _roleRepository = new RoleRepository();
        }
        public OrgChartModel GetOrgChart()
        {


            UsersModel user;
            try
            {

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Org Chart", "Org Chart Service"));

                user = _userRepository.UserDetails(GetParentOfOrgChart());
                if (user == null)
                    return null;
                else
                {
                    OrgChartModel orgChartModel = new OrgChartModel
                    {
                        UserId = user.Id,
                        UserName = user.FirstName +" "+ user.SurName,
                        Image = user.ProfileImage,
                        Designation = _designationRepository.GetDesignationName(_employeeDesignationRepository.GetDesignationId(_employeeRepository.GetEmployeeId(user.Id))),
                        childOrgChart = GetChildrenOfParent(_employeeReportToRepository.GetDependentEmployees(_employeeRepository.GetEmployeeId(user.Id)))
                    };
                    return orgChartModel;
                }       
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetOrgChart", "OrgChartService ", exception.Message), exception);


                throw;
            }
        }

        public List<OrgChartModel> GetChildrenOfParent(List<EmployeeReportToDbEntity> dependentEmployees)
        {

            List<OrgChartModel> OrgChartModels = new List<OrgChartModel>();
            UsersModel user;
            List<UserDbEntity> users=new List<UserDbEntity>();

            foreach (var dependentEmployee in dependentEmployees)
            {
                user = _userRepository.UserDetails(_userRepository.GetUserId(dependentEmployee.EmployeeId));
                if (user == null)
                    continue;
                if (user.IsActive != true)
                    continue;
                OrgChartModel orgChartModel = new OrgChartModel
                {
                    UserId = user.Id,
                    UserName = user.FirstName +" "+ user.SurName,
                    Image = user.ProfileImage,
                    Designation = _designationRepository.GetDesignationName(_employeeDesignationRepository.GetDesignationId(_employeeRepository.GetEmployeeId(user.Id))),
                    childOrgChart = GetChildrenOfParent(_employeeReportToRepository.GetDependentEmployees(dependentEmployee.EmployeeId))
                };
                OrgChartModels.Add(orgChartModel);

            }

            return OrgChartModels.OrderBy(x => x.UserName).ToList();
        }

        public Guid GetParentOfOrgChart()
        {
            bool isAdmin = true;
            string RoleName = "";
            Guid parentOfOrgChart = Guid.Empty;
            IEnumerable<UserDbEntity> userDbEntities;
            List<EmployeeReportToDbEntity> employeeReportToDbEntities;

            userDbEntities = _userRepository.SelectAll().Where(x => x.IsActive.Equals(true)).Select(x => x);
           
            foreach (UserDbEntity user in userDbEntities)
            {
                Guid employeeId = _employeeRepository.GetEmployeeId(user.Id);
                employeeReportToDbEntities = _employeeReportToRepository.SelectAll().Where(x => x.EmployeeId == employeeId).ToList();
                
                if(employeeReportToDbEntities.Count != 0)
                {
                    isAdmin = false;
                }

                //RoleName = _roleRepository.GetRoleName(user.RoleId)??"empty";
                
                if (isAdmin == true && RoleName.Equals(AppConstants.RoleNameOfHeadOfTheCompany))
                {
                    parentOfOrgChart = user.Id;
                    break;
                }
                else
                    isAdmin = true;
            }
            return parentOfOrgChart;
        }
    }
}
