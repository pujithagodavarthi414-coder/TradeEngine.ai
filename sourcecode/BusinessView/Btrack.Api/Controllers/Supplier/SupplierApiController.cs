using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Supplier;
using Btrak.Services.Suppliers;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Supplier
{
    public class SupplierApiController : AuthTokenApiController
    {
        private readonly ISupplierServices _supplierService;

        private BtrakJsonResult _btrakJsonResult;

        public SupplierApiController()
        {
            _supplierService = new SupplierServices();

            _btrakJsonResult = new BtrakJsonResult
            {
                Success = false
            };
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertSupplier)]
        public JsonResult<BtrakJsonResult> UpsertSupplier(SupplierDetailsInputModel supplierInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertSupplier", "supplierInputModel", supplierInputModel, "SupplierApi"));
                LoggingManager.Debug(supplierInputModel.ToString());
                if (ModelState.IsValid)
                {
                    var validationMessages  = new List<ValidationMessage>();
                    var supplierId = _supplierService.UpsertSupplier(supplierInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Supplier", "Supplier Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Supplier Started", "Supplier Management Api"));
                    LoggingManager.Debug("supplierId : " + supplierId);
                    return Json(new BtrakJsonResult { Success = true, Data = supplierId }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Supplier Ended", "Supplier Management Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
               
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSupplier", "SupplierApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchSupplier)]
        public JsonResult<BtrakJsonResult> SearchSuppliers(SupplierSearchCriteriaInputModel suppliersSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Supplier", "suppliersSearchModel", suppliersSearchModel, "Supplier Api"));
                LoggingManager.Debug(suppliersSearchModel.ToString());
                var validationMessages = new List<ValidationMessage>();
                var supplierList = _supplierService.SearchSupplier(suppliersSearchModel, LoggedInContext,validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Supplier", "Supplier Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Supplier", "Supplier Api"));
                return Json(new BtrakJsonResult { Success = true, Data = supplierList }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSuppliers", "SupplierApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetSuppliersDropDown)]
        public JsonResult<BtrakJsonResult> GetSuppliersDropDown(string searchText)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSuppliersDropDown", "Suppliers Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                List<SuppliersDropDownOutputModel> suppliersList = _supplierService.GetSupplierDropDown(searchText, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSuppliersDropDown", "Suppliers Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSuppliersDropDown ", "Suppliers Api"));
                return Json(new BtrakJsonResult { Data = suppliersList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSuppliersDropDown", "SupplierApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetSupplierById)]
        public JsonResult<BtrakJsonResult> GetSupplierById(Guid? supplierId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get supplier by Id", "supplierId", supplierId, "Supplier Api"));
                LoggingManager.Debug("supplierId : " + supplierId);
                var validationMessages = new List<ValidationMessage>();
                var supplierList = _supplierService.GetSupplierById(supplierId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Supplier", "Supplier Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get supplier by Id", "Supplier Api"));
                return Json(new BtrakJsonResult { Success = true, Data = supplierList }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSupplierById", "SupplierApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }



        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAllSuppliers)]
        public JsonResult<BtrakJsonResult> GetAllSuppliers(string searchText)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get all suppliers", "searchText", searchText, "Supplier Api"));
                LoggingManager.Debug("searchText : " + searchText);
                var validationMessages = new List<ValidationMessage>();
                var supplierList = _supplierService.GetAllSuppliers(searchText,LoggedInContext,validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get all suppliers", "Supplier Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get all suppliers", "Supplier Api"));
                return Json(new BtrakJsonResult { Success = true, Data = supplierList }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllSuppliers", "SupplierApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
