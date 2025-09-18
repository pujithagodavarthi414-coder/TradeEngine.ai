using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.ButtonType;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.ButtonTypeValidationHelpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.ButtonType
{
    public class ButtonTypeService : IButtonTypeService
    {
        private readonly ButtonTypeRepository _buttonTypeRepository;
        private readonly IAuditService _auditService;

        public ButtonTypeService(ButtonTypeRepository buttonTypeRepository, IAuditService auditService)
        {
            _buttonTypeRepository = buttonTypeRepository;
            _auditService = auditService;
        }

        public Guid? UpsertButtonType(ButtonTypeInputModel buttonTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertButtonType", "ButtonTypeService"));

            LoggingManager.Debug(buttonTypeInputModel.ToString());

            if (!ButtonTypeValidationsHelper.UpsertButtonTypeValidation(buttonTypeInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            buttonTypeInputModel.ButtonTypeId = _buttonTypeRepository.UpsertButtonType(buttonTypeInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertButtonTypeCommandId, buttonTypeInputModel, loggedInContext);

            LoggingManager.Debug(buttonTypeInputModel.ButtonTypeId?.ToString());

            return buttonTypeInputModel.ButtonTypeId;
        }

        public List<ButtonTypeOutputModel> GetAllButtonTypes(ButtonTypeInputModel buttonTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllButtonTypes", "buttonTypeInputModel", buttonTypeInputModel, "ButtonType Service"));

            LoggingManager.Debug(buttonTypeInputModel?.ToString());

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetAllButtonTypesCommandId, buttonTypeInputModel, loggedInContext);

            List<ButtonTypeOutputModel> buttonTypeModels = _buttonTypeRepository.GetAllButtonTypes(buttonTypeInputModel, loggedInContext, validationMessages);
            return buttonTypeModels;
        }

        public ButtonTypeOutputModel GetButtonTypeById(Guid? buttonTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(buttonTypeId?.ToString());

            if (!ButtonTypeValidationsHelper.GetButtonTypeByIdValidation(buttonTypeId, loggedInContext, validationMessages))
            {
                return null;
            }

            ButtonTypeInputModel buttonTypeModel = new ButtonTypeInputModel
            {
                ButtonTypeId = buttonTypeId
            };

            _auditService.SaveAudit(AppCommandConstants.GetButtonTypeByIdCommandId, buttonTypeModel, loggedInContext);

            ButtonTypeOutputModel buttonTypeInputModel = _buttonTypeRepository.GetAllButtonTypes(buttonTypeModel, loggedInContext, validationMessages).FirstOrDefault();
            return buttonTypeInputModel;
        }

        public ButtonTypeByIdOutputModel GetButtonTypeDetailsById(Guid? buttonTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetButtonTypeDetailsById", "buttonTypeId", buttonTypeId, "ButtonType Service"));
            ButtonTypeByIdOutputModel buttontypeDetails = _buttonTypeRepository.GetButtonTypeById(buttonTypeId, loggedInContext, validationMessages);
            return buttontypeDetails;
        }
    }
}
