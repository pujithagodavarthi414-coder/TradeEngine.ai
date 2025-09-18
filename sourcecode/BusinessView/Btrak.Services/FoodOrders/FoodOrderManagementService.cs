using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.FoodOrders;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.FoodOrderManagementValidationHelpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.FoodOrders
{
    public class FoodOrderManagementService : IFoodOrderManagementService
    {
        private readonly FoodOrderRepository _foodOrderRepository;
        private readonly IAuditService _auditService;
        public FoodOrderManagementService(FoodOrderRepository foodOrderRepository, IAuditService auditService)
        {
            _foodOrderRepository = foodOrderRepository;
            _auditService = auditService;
        }

        public Guid? UpsertFoodOrder(FoodOrderManagementInputModel foodOrderManagementInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertFoodOrder", "foodOrderManagementInputModel", foodOrderManagementInputModel, "FoodOrderManagementService"));

            LoggingManager.Debug(foodOrderManagementInputModel.ToString());

            FoodOrderManagementValidationHelper.CheckFoodOrderValidationMessages(foodOrderManagementInputModel, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            string xmlOfMemberId = Utilities.ConvertIntoListXml(foodOrderManagementInputModel.MemberId);
           
            foodOrderManagementInputModel.FoodOrderId = _foodOrderRepository.UpsertFoodOrder(foodOrderManagementInputModel, loggedInContext, validationMessages, xmlOfMemberId);
            LoggingManager.Debug("FoodOrder with the id " + foodOrderManagementInputModel.FoodOrderId);
            _auditService.SaveAudit(AppCommandConstants.UpsertFoodOrderCommandId, foodOrderManagementInputModel, loggedInContext);
            return foodOrderManagementInputModel.FoodOrderId;
        }

        public List<FoodOrderManagementApiReturnModel> SearchFoodOrders(FoodOrderManagementSearchCriteriaInputModel foodOrderManagementSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchFoodOrders", "foodOrderManagementSearchCriteriaInputModel", foodOrderManagementSearchCriteriaInputModel, "FoodOrderManagementService"));

            LoggingManager.Debug(foodOrderManagementSearchCriteriaInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchFoodOrderCommandId, foodOrderManagementSearchCriteriaInputModel, loggedInContext);
            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, foodOrderManagementSearchCriteriaInputModel, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            LoggingManager.Info("Getting FoodOrders search list ");
            List<FoodOrderManagementApiReturnModel> foodOrderReturnList = _foodOrderRepository.SearchFoodOrders(foodOrderManagementSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
           
            return foodOrderReturnList;
        }

        public FoodOrderManagementApiReturnModel GetFoodOrderById(Guid? foodOrderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetFoodOrderById", "foodOrderId", foodOrderId, "FoodOrderManagementService"));
            _auditService.SaveAudit(AppCommandConstants.GetFoodOrderByIdCommandId, foodOrderId, loggedInContext);
            FoodOrderManagementValidationHelper.CheckGetFoodOrderByIdValidationMessages(foodOrderId, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            FoodOrderManagementSearchCriteriaInputModel searchCriteriaModel = new FoodOrderManagementSearchCriteriaInputModel { FoodOrderId = foodOrderId };
            LoggingManager.Info("Getting Food OrderDetails by Id ");
            FoodOrderManagementApiReturnModel foodOrderManagementReturnModel = _foodOrderRepository.SearchFoodOrders(searchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();
           
            LoggingManager.Debug(foodOrderManagementReturnModel?.ToString());

            if (foodOrderManagementReturnModel != null) return foodOrderManagementReturnModel;

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundFoodOrderWithTheId, foodOrderId)
            });
            return null;

        }

        public List<FoodOrderManagementSpReturnModel> GetMonthlyFoodOrderReport(FoodOrderManagementSearchCriteriaInputModel foodOrderManagementSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMonthlyFoodOrderReport", "foodOrderManagementSearchCriteriaInputModel", foodOrderManagementSearchCriteriaInputModel, "FoodOrderManagementService"));

            if (foodOrderManagementSearchCriteriaInputModel.Date == null)
            {
                foodOrderManagementSearchCriteriaInputModel.Date = DateTime.Now;
            }

            _auditService.SaveAudit(AppCommandConstants.GetMonthlyFoodOrderReportCommandId, foodOrderManagementSearchCriteriaInputModel, loggedInContext);
            FoodOrderManagementValidationHelper.CheckMonthlyFoodOrderReportValidationMessages(foodOrderManagementSearchCriteriaInputModel, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            
            List<FoodOrderManagementSpReturnModel> foodOrderReturnList = _foodOrderRepository.GetMonthlyFoodOrderReport(foodOrderManagementSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
           
            return foodOrderReturnList;
        }

        public Guid? ChangeFoodOrderStatus(ChangeFoodOrderStatusInputModel changeFoodOrderStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ChangeFoodOrderStatus", "changeFoodOrderStatusInputModel", changeFoodOrderStatusInputModel, "FoodOrderManagementService"));
            FoodOrderManagementValidationHelper.CheckFoodOrderStatusValidationMessages(changeFoodOrderStatusInputModel, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            Guid? foodOrderId = _foodOrderRepository.ChangeFoodOrderStatus(changeFoodOrderStatusInputModel, loggedInContext, validationMessages);
            _auditService.SaveAudit(AppCommandConstants.ChangeFoodOrderStatusCommandId, changeFoodOrderStatusInputModel, loggedInContext);
            LoggingManager.Debug(foodOrderId?.ToString());
            return foodOrderId;
        }
    }
}
