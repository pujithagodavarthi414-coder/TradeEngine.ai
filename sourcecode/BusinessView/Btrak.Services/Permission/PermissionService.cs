using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CrudOperation;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;
using System;
using System.Linq;
using System.Collections.Generic;
using Btrak.Services.Helpers.CrudOperation;

namespace Btrak.Services.Permission
{
    public class PermissionService : IPermissionService
    {
        private readonly CrudOperationRepository _crudOperationRepository;

        private readonly IAuditService _auditService;

        public PermissionService(CrudOperationRepository crudOperationRepository, IAuditService auditService)
        {
            _crudOperationRepository = crudOperationRepository;
            _auditService = auditService;
        }

        public Guid? UpsertPermission(CrudOperationInputModel crudOperationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            crudOperationInputModel.OperationName = crudOperationInputModel.OperationName?.Trim();

            LoggingManager.Debug(crudOperationInputModel.ToString());

            if (!CrudOperationValidations.ValidateUpsertPermission(crudOperationInputModel.OperationName, loggedInContext, validationMessages))
            {
                return null;
            }

            if (crudOperationInputModel.CrudOperationId == Guid.Empty || crudOperationInputModel.CrudOperationId == null)
            {
                crudOperationInputModel.CrudOperationId = _crudOperationRepository.UpsertPermission(crudOperationInputModel, loggedInContext, validationMessages);

                if (crudOperationInputModel.CrudOperationId != Guid.Empty)
                {
                    LoggingManager.Debug("New Permission with the id " + crudOperationInputModel.CrudOperationId + " has been created.");

                    _auditService.SaveAudit(AppCommandConstants.UpsertPermissionCommandId, crudOperationInputModel, loggedInContext);

                    return crudOperationInputModel.CrudOperationId;
                }

                throw new Exception(ValidationMessages.ExceptionPermissionCouldNotBeCreated);
            }

            crudOperationInputModel.CrudOperationId = _crudOperationRepository.UpsertPermission(crudOperationInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Permission with the id " + crudOperationInputModel.CrudOperationId + " has been updated.");

            _auditService.SaveAudit(AppCommandConstants.UpsertPermissionCommandId, crudOperationInputModel, loggedInContext);

            return crudOperationInputModel.CrudOperationId;
        }

        public List<CrudOperationApiReturnModel> GetAllPermissions(CrudOperationInputModel crudOperationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered to GetAllPermissions." + "Logged in User Id=" + loggedInContext);

            _auditService.SaveAudit(AppCommandConstants.GetAllPermissionsCommandId, crudOperationInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<CrudOperationApiReturnModel> crudOperationReturnModels = _crudOperationRepository.GetAllCrudOperations(crudOperationInputModel, loggedInContext, validationMessages);
            
            return crudOperationReturnModels;
        }

        public CrudOperationApiReturnModel GetPermissionById(Guid? permissionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPermissionById", "Permission Service"));

            if (!CrudOperationValidations.ValidatePermissionById(permissionId, loggedInContext, validationMessages))
            {
                return null;
            }

            var crudOperationInputModel = new CrudOperationInputModel
            {
                CrudOperationId = permissionId
            };

            CrudOperationApiReturnModel crudOperationSpReturnModel = _crudOperationRepository.GetAllCrudOperations(crudOperationInputModel, loggedInContext,validationMessages).FirstOrDefault();

            if (!CrudOperationValidations.ValidatePermissionFoundWithId(permissionId, validationMessages, crudOperationSpReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetPermissionsByIdCommandId, crudOperationInputModel, loggedInContext);
            
            return crudOperationSpReturnModel;
        }
    }
}
