using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Products;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.ProductValidationHelpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.Products
{
    public class ProductServices : IProductServices
    {
        private readonly ProductRepository _productRepository = new ProductRepository();
        private readonly ProductDetailRepository _productDetailRepository = new ProductDetailRepository();
        private readonly AuditService _auditService = new AuditService();

        public Guid? UpsertProduct(ProductInputModel productModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertProduct", "productModel", productModel, "Product Service"));
            LoggingManager.Debug(productModel.ToString());
            if (!ProductValidationHelper.UpsertProductValidation(productModel, loggedInContext, validationMessages))
            {
                return null;
            }

            productModel.ProductId = _productRepository.UpsertProduct(productModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Product with the id " + productModel.ProductId + " has been added.");
            _auditService.SaveAudit(AppCommandConstants.UpsertProductCommandId, productModel, loggedInContext);
            LoggingManager.Info("ProductId : " + productModel.ProductId);
            return productModel.ProductId;
        }

        public Guid? UpsertProductDetails(ProductDetailsInputModel productDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Product Details", "productDetailsModel", productDetailsModel, "Product Service"));
            LoggingManager.Info("Entered Upsert Product Details with " + productDetailsModel.ProductId + " identifier");

            if (!ProductValidationHelper.UpsertProductDetailsValidation(productDetailsModel, loggedInContext, validationMessages))
            {
                return null;
            }
           
            productDetailsModel.ProductDetailsId = _productDetailRepository.UpsertProductDetails(productDetailsModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Product Detail with the id " + productDetailsModel.ProductDetailsId + " has been added.");
            _auditService.SaveAudit(AppCommandConstants.UpsertProductDetailsCommandId, productDetailsModel, loggedInContext);
            LoggingManager.Debug(productDetailsModel.ProductDetailsId.ToString());
            return productDetailsModel.ProductDetailsId;
        }

        public List<ProductOutputModel> SearchProduct(ProductSearchCriteriaInputModel productSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchProduct", "productSearchCriteriaInputModel", productSearchCriteriaInputModel, "Product Service"));
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, productSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }
            return _productRepository.SearchProducts(productSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
        }

        public ProductOutputModel GetProductById(Guid? productId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Product with not null identifier", "Product Service"));
            LoggingManager.Debug("productId : " + productId);
            if (!ProductValidationHelper.ProductByIdValidation(productId, loggedInContext, validationMessages))
            {
                return null;
            }

            ProductOutputModel productDetails = _productRepository.GetProductById(productId, loggedInContext, validationMessages);
            return validationMessages.Any() ? null : productDetails;
        }

        public ProductDetailsOutputModel GetProductDetailsById(Guid? productId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Product Details with not null identifier", "Product Service"));
            LoggingManager.Debug("productId : " + productId);
            if (!ProductValidationHelper.ProductDetailsByIdValidation(productId, loggedInContext, validationMessages))
            {
                return null;
            }
            ProductDetailsOutputModel productDetails = _productDetailRepository.GetProductDetailsById(productId, loggedInContext.LoggedInUserId, validationMessages);
            return validationMessages.Any() ? null : productDetails;
        }

        public List<ProductDetailsOutputModel> GetAllProductDetails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get all Product Details", "Product Service"));
            return _productDetailRepository.GetAllProductDetails(loggedInContext.LoggedInUserId, validationMessages);
        }

        public List<ProductOutputModel> GetAllProducts(ProductSearchCriteriaInputModel productSearchCriteriaInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get all Product", "Product Service"));
            return _productRepository.GetAllProducts(productSearchCriteriaInputModel,loggedInContext.LoggedInUserId, validationMessages);
        }

        public List<ProductDetailsOutputModel> SearchProductDetails(ProductDetailsSearchCriteriaInputModel productDetailsSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search Product Details", "Product Service"));

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, productDetailsSearchModel,
                validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Product Details", "Product Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchProductDetailsCommandId, productDetailsSearchModel, loggedInContext);
            return _productDetailRepository.SearchProductDetails(productDetailsSearchModel, loggedInContext.LoggedInUserId, validationMessages).ToList();
        }
    }
}
