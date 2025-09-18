using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Products;
using Btrak.Services.Products;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Products
{
    public class ProductsApiController : AuthTokenApiController
    {
        private readonly IProductServices _productService;
        private BtrakJsonResult _btrakJsonResult;

        public ProductsApiController()
        {
            _productService = new ProductServices();
            _btrakJsonResult = new BtrakJsonResult
            {
                Success = false
            };
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertProduct)]
        public JsonResult<BtrakJsonResult> UpsertProduct(ProductInputModel productModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertProduct", "productModel", productModel, "Products Api"));
                LoggingManager.Debug(productModel.ToString());
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? productId = _productService.UpsertProduct(productModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Product Upsert is completed. Return Guid is " + productId + ", source command is " + productModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProduct", "UpsertProduct Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProduct", "UpsertProduct Api"));
                LoggingManager.Debug("productId : " + productId);
                return Json(new BtrakJsonResult { Data = productId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProduct", " ProductsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllProducts)]
        public JsonResult<BtrakJsonResult> GetAllProducts(ProductSearchCriteriaInputModel productSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get all Products", "Product Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<ProductOutputModel> product = _productService.GetAllProducts(productSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get all Products", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get all Products", "Product Api"));
                LoggingManager.Debug("product :" + product);
                return Json(new BtrakJsonResult { Success = true, Data = product }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllProducts", " ProductsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertProductDetails)]
        public JsonResult<BtrakJsonResult> UpsertProductDetails(ProductDetailsInputModel productDetailsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertProductDetails", "productDetailsModel", productDetailsModel, "Products Api"));
                LoggingManager.Debug(productDetailsModel.ToString());
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? productDetailsId = _productService.UpsertProductDetails(productDetailsModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Product Upsert is completed. Return Guid is " + productDetailsId + ", source command is " + productDetailsModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProductDetails", "UpsertProduct Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProductDetails", "UpsertProduct Api"));
                LoggingManager.Debug("productDetailsId : " +productDetailsId);
                return Json(new BtrakJsonResult { Data = productDetailsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProductDetails", " ProductsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchProductDetails)]
        public JsonResult<BtrakJsonResult> SearchProductDetails(ProductDetailsSearchCriteriaInputModel productDetailsSearchCriteriaInputModel)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Product Details", "productDetailsSearchCriteriaInputModel", productDetailsSearchCriteriaInputModel, "Products Api"));
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchProductDetails", "productDetailsSearchCriteriaInputModel", productDetailsSearchCriteriaInputModel, "Products Api"));
                if (productDetailsSearchCriteriaInputModel == null)
                {
                    productDetailsSearchCriteriaInputModel = new ProductDetailsSearchCriteriaInputModel();
                }
                LoggingManager.Debug(productDetailsSearchCriteriaInputModel.ToString());

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting productDetails List ");
                var productDetailsList = _productService.SearchProductDetails(productDetailsSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchProductDetails", "Products Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchProductDetails", "Products Api"));
                return Json(new BtrakJsonResult { Data = productDetailsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchProductDetails", " ProductsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }



        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchByProduct)]
        public JsonResult<BtrakJsonResult> SearchByProduct(ProductSearchCriteriaInputModel productSearchCriteriaInputModel)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchByProduct", "productSearchCriteriaInputModel", productSearchCriteriaInputModel, "Products Api"));
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchByProduct", "productSearchCriteriaInputModel", productSearchCriteriaInputModel, "Products Api"));
                if (productSearchCriteriaInputModel == null)
                {
                    productSearchCriteriaInputModel = new ProductSearchCriteriaInputModel();
                }
                LoggingManager.Debug(productSearchCriteriaInputModel.ToString());

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting products List ");
                var productsList = _productService.SearchProduct(productSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchProducts", "Products Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchProducts", "Products Api"));
                return Json(new BtrakJsonResult { Data = productsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchProducts)
                });

                return null;
            }
        }
        
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetProductById)]
        public JsonResult<BtrakJsonResult> GetProductById(Guid productId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProductById", "productId", productId, "Products Api"));
                LoggingManager.Debug("productId :" + productId);
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                ProductOutputModel product = _productService.GetProductById(productId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Product by Id", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Product by Id", "Product Api"));
                LoggingManager.Debug(product.ToString());
                return Json(new BtrakJsonResult { Success = true, Data = product }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProductById", " ProductsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetProductDetailsById)]
        public JsonResult<BtrakJsonResult> GetProductDetailsById(Guid productDetailsId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Product Details by Id", "productDetailsId", productDetailsId, "Products Api"));
                LoggingManager.Debug("productDetailsId :" + productDetailsId);
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                ProductDetailsOutputModel product = _productService.GetProductDetailsById(productDetailsId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Product details by Id", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Product Details by Id", "Product Api"));
                LoggingManager.Debug("product :" + product);
                return Json(new BtrakJsonResult { Success = true, Data = product }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProductDetailsById", " ProductsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAllProductDetails)]
        public JsonResult<BtrakJsonResult> GetAllProductDetails()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get all Product Details", "Product Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<ProductDetailsOutputModel> product = _productService.GetAllProductDetails(LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get all Product details", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get all Product Details", "Product Api"));
                LoggingManager.Debug("product :" + product);
                return Json(new BtrakJsonResult { Success = true, Data = product }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllProductDetails", " ProductsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
