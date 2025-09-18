using System;
using Btrak.Models;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models.Branch;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Branch;
using BTrak.Common;
using Newtonsoft.Json;
using Btrak.Models.Employee;

namespace Btrak.Services.Branch
{
    public class BranchService : IBranchService
    {
        private readonly BranchRepository _branchRepository;
        private readonly IAuditService _auditService;

        public BranchService(BranchRepository branchRepository, IAuditService auditService)
        {
            _branchRepository = branchRepository;
            _auditService = auditService;
        }

        public Guid? UpsertBranch(BranchUpsertInputModel branchUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertBranch", "Branch Service"));

            branchUpsertInputModel.BranchName = branchUpsertInputModel.BranchName?.Trim();

            LoggingManager.Debug(branchUpsertInputModel.ToString());

            if (!BranchValidations.ValidateUpsertBranch(branchUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            branchUpsertInputModel.AddressJSON = Utilities.ConvertObjectToJSON(new Address
            {
                City = branchUpsertInputModel.City,
                PostalCode = branchUpsertInputModel.PostalCode,
                Street = branchUpsertInputModel.Street,
                State = branchUpsertInputModel.State
            });

            branchUpsertInputModel.BranchId = _branchRepository.UpsertBranch(branchUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertBranchCommandId, branchUpsertInputModel, loggedInContext);

            LoggingManager.Debug(branchUpsertInputModel.BranchId?.ToString());

            return branchUpsertInputModel.BranchId;
        }

        public List<BranchApiReturnModel> GetAllBranches(BranchSearchInputModel branchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllBranches", "Branch Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAllBranchesCommandId, branchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<BranchApiReturnModel> branchReturnModels = _branchRepository.GetAllBranches(branchInputModel, loggedInContext, validationMessages).ToList();

            for (int i = 0; i < branchReturnModels.Count; i++)
            {
                if (branchReturnModels[i].Address != null)
                {
                    Address result = JsonConvert.DeserializeObject<Address>(branchReturnModels[i].Address);
                    branchReturnModels[i].City = result.City;
                    branchReturnModels[i].Street = result.Street;
                    branchReturnModels[i].State = result.State;
                    branchReturnModels[i].PostalCode = result.PostalCode;
                }
            }
            return branchReturnModels;
        }

        public List<BranchApiDropdownReturnModel> GetAllBranchesDropdown(BranchSearchInputModel branchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllBranchesDropdown", "Branch Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAllBranchesCommandId, branchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<BranchApiDropdownReturnModel> branchReturnModels = _branchRepository.GetAllBranchesDropdown(branchInputModel, loggedInContext, validationMessages).ToList();
            
            return branchReturnModels;
        }

        public EmployeeOutputModel GetUserBranchDetails(EmployeeInputModel userInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserBranchDetails", "Branch Service"));

            LoggingManager.Debug(userInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAllBranchesCommandId, userInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            EmployeeOutputModel branchReturnModels = _branchRepository.GetUserBranchDetails(userInputModel, loggedInContext, validationMessages);
            
            return branchReturnModels;
        }
    }
}
