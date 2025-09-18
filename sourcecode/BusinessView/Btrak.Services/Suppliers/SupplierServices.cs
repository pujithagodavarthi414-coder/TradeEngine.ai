using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Supplier;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.SupplierValidationHelpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.Suppliers
{
    public class SupplierServices : ISupplierServices
    {
        private readonly SupplierRepository _supplierRepository = new SupplierRepository();

        private readonly AuditService _auditService = new AuditService();

        public Guid? UpsertSupplier(SupplierDetailsInputModel supplierInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertSupplier", "supplierInputModel", supplierInputModel, "SupplierService"));
            LoggingManager.Debug(supplierInputModel.ToString());
            if (!SupplierValidationHelper.UpsertSupplierValidation(supplierInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? supplierId = _supplierRepository.UpsertSupplier(supplierInputModel, loggedInContext, validationMessages);
            if (supplierId != Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Supplier audit saving", "Supplier Service"));

                _auditService.SaveAudit(AppCommandConstants.UpsertSupplierCommandId, supplierInputModel, loggedInContext);
                return supplierId;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Supplier", "Supplier Service"));
            return null;
        }

        public List<SupplierDetailsOutputModel> SearchSupplier(SupplierSearchCriteriaInputModel suppliersSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchSupplier", "suppliersSearchModel", suppliersSearchModel, "Supplier Service"));
            LoggingManager.Debug(suppliersSearchModel.ToString());
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, suppliersSearchModel, validationMessages))
            {
                return null;
            }
            return _supplierRepository.SearchSupplier(suppliersSearchModel, loggedInContext, validationMessages).ToList();
        }

        public List<SuppliersDropDownOutputModel> GetSupplierDropDown(string searchText , LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetSupplierDropDown", "searchText", searchText, "Supplier Service"));
            LoggingManager.Debug(searchText);
            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }
            return _supplierRepository.GetSuppliersDropDown(searchText, loggedInContext, validationMessages).ToList();
        }

        public List<SupplierDetailsOutputModel> GetSupplierById(Guid? supplierId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetSupplierById", "supplierId", supplierId, "Supplier Service"));
            LoggingManager.Debug("supplierId : " + supplierId);
            if (!SupplierValidationHelper.SupplierByIdValidation(supplierId, loggedInContext, validationMessages))
            {
                return null;
            }
            SupplierSearchCriteriaInputModel supplierSearchCriteriaInputModel = new SupplierSearchCriteriaInputModel()
            {
                SupplierId=supplierId
            };
            var supplierDetails = _supplierRepository.SearchSupplier(supplierSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            LoggingManager.Debug(supplierDetails.ToString());
            return supplierDetails;
        }

        public List<SupplierDetailsOutputModel> GetAllSuppliers(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllSuppliers", "searchText", searchText, "Supplier Service"));
            return _supplierRepository.GetAllSuppliers(searchText, loggedInContext, validationMessages).ToList();
        }
    }
}

