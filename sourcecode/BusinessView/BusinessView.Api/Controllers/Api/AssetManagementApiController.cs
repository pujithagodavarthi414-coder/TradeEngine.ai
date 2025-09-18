using BusinessView.Common;
using BusinessView.DAL;
using BusinessView.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using BusinessView.Api.Models;
using Microsoft.AspNet.Identity;
using BusinessView.Services;
using BusinessView.Services.Interfaces;

namespace BusinessView.Api.Controllers.Api
{
    public class AssetManagementApiController : ApiController
    {
        private readonly BViewEntities _bview = new BViewEntities();
        private readonly IAssetManagement _assetManagementService;

        public AssetManagementApiController()
        {
            _assetManagementService = new AssetManagementService();
        }

        [HttpGet]
        public List<AssetAssignedUserModel> GetAssignees()
        {
            return _assetManagementService.GetAssignees();
        }

        [HttpGet]
        public List<AssetViewModel> GetAssigneesList()
        {
            return _assetManagementService.GetRecentlyPurchasedAssets();
        }

        [HttpGet]
        public List<AssetViewModel> GetDamagedAssets()
        {
            return _assetManagementService.GetDamagedAssets();
        }

        [HttpGet]
        public List<AssetAssignedUserModel> GetAssetsAssignedToMe()
        {
            var userId = User.Identity.GetUserId<int>();
            return _assetManagementService.AssignedToMe(userId);
        }


        [HttpPost]
        public string AddNewProduct(ProductNameModel productNameModel)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add New Product", "Asset Management Api"));

            if (ModelState.IsValid)
            {
                var productName = new ProductName
                {
                    Id = productNameModel.Id,
                    Name = productNameModel.Name,
                    CreatedDate = DateTime.Now
                };
                _bview.ProductNames.Add(productName);
                _bview.SaveChanges();

                var businessViewJsonResult = new BusinessViewJsonResult
                {
                    Success = true,
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add New Product", "Asset Management Api"));

                return JsonConvert.SerializeObject(businessViewJsonResult);
            }

            var viewJsonResult = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add New Product", "Asset Management Api"));
            return JsonConvert.SerializeObject(viewJsonResult);
        }

        [HttpPost]
        public string SaveSupplier(SupplierModel supplierModel)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Save Supplier", "Asset Management Api"));

            if (!string.IsNullOrWhiteSpace(supplierModel.CreatedDateValue))
            {
                supplierModel.CreatedDate = Convert.ToDateTime(supplierModel.CreatedDateValue);
            }
            if (!string.IsNullOrWhiteSpace(supplierModel.StartedWorkingFromValue))
            {
                supplierModel.StartedWorkingFrom = Convert.ToDateTime(supplierModel.StartedWorkingFromValue);
            }
            if (ModelState.IsValid)
            {
                var supplier = new Supplier
                {
                    SupplierId = supplierModel.SupplierId,
                    SupplierName = supplierModel.SupplierName,
                    CreatedDate = supplierModel.CreatedDate,
                    CompanyName = supplierModel.CompanyName,
                    ContactPerson = supplierModel.ContactPerson,
                    ContactPosition = supplierModel.ContactPosition,
                    CompanyPhoneNumber = supplierModel.CompanyPhoneNumber,
                    ContactPhoneNumber = supplierModel.ContactPhoneNumber,
                    VendorIntroducedBy = supplierModel.VendorIntroducedBy,
                    StartedWorkingFrom = supplierModel.StartedWorkingFrom
                };
                _bview.Suppliers.Add(supplier);
                _bview.SaveChanges();

                var businessViewJsonResult = new BusinessViewJsonResult
                {
                    Success = true,
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Save Supplier", "Asset Management Api"));

                return JsonConvert.SerializeObject(businessViewJsonResult);
            }

            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Save Supplier", "Asset Management Api"));
            return JsonConvert.SerializeObject(result2);
        }

        [HttpPost]
        public string AddProduct(ProductTableModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add  Product", "Asset Management Api"));

            if (ModelState.IsValid)
            {
                var assetProductId = _bview.ProductNames.Where(x => x.Name.Contains(model.productname.Trim())).Select(x => x.Id).FirstOrDefault();
                if (assetProductId == 0)
                {
                    ModelState.AddModelError("", "Product Name was not there in the list.");
                    var resultValue = new BusinessViewJsonResult
                    {
                        Success = false,
                        ModelState = ModelState
                    };
                    return JsonConvert.SerializeObject(resultValue);
                }
                var assetSupplierId = _bview.Suppliers.Where(x => x.SupplierName.Contains(model.suppliername.Trim())).Select(x => x.SupplierId).FirstOrDefault();
              
                var productdata = new ProductTable
                {
                    ProductId = assetProductId != 0 ? assetProductId : (int?)null,
                    SupplierId = assetSupplierId != 0 ? assetSupplierId : (int?)null,
                    ProductTypeId = model.ProductTypeId,
                    ProductCode = model.ProductCode,
                    CreatedDate = DateTime.Now,
                    ManufacturerCode = model.ManufacturerCode,
                    
                };
                _bview.ProductTables.Add(productdata);
                _bview.SaveChanges();
                var result1 = new BusinessViewJsonResult
                {
                    Success = true,
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add  Product", "Asset Management Api"));

                return JsonConvert.SerializeObject(result1);
            }
            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add  Product", "Asset Management Api"));
            return JsonConvert.SerializeObject(result2);
        }

        [HttpPost]
        public string AddNewAsset(AssetViewModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add New Asset", "Asset Management Api"));

            if (!string.IsNullOrWhiteSpace(model.PurchasedDateValue))
            {
                model.PurchaseDate = Convert.ToDateTime(model.PurchasedDateValue);
            }
            if (!string.IsNullOrWhiteSpace(model.ApprovedDateTimeValue))
            {
                model.ApprovedDateTime = Convert.ToDateTime(model.ApprovedDateTimeValue);
            }
            ModelState.Remove("model.Assignedto");
            if (ModelState.IsValid)
            {
                var assetProductNameId = _bview.ProductNames.Where(y => y.Name.ToLower() == model.ProductName.Trim().ToLower()).Select(x => x.Id).FirstOrDefault();
               
                var assetName = new Asset
                {
                    Id = model.Id,
                    AssetId = model.AssetId,
                    ProductId = assetProductNameId != 0 ? assetProductNameId : (int?)null,
                    PurchaseDate = model.PurchaseDate,
                    CreatedDate = DateTime.Now,
                    LocationId = model.LocationId,
                    Cost = model.Cost,
                    CostCurrency = model.CostCurrency,
                    ApprovedByUserId = model.ApprovedByUserId,
                    ApprovedDateTime = model.ApprovedDateTime,
                    DamagedDate = model.DamagedDate,
                    DamagedReason = model.DamagedReason,
                    AssetName = model.AssetName,
                    ProductName = model.ProductName,
                    ManufacturerId = model.ManufacturerId,
                    IsVendor = model.IsVendor,
                    IsEmpty = model.IsEmpty
                };
                _bview.Assets.Add(assetName);
                _bview.SaveChanges();

                //VendorDatails table
                var recentId = _bview.Assets.Max(item => item.Id);
                var recentDataDetails = _bview.Assets.FirstOrDefault(x => x.Id == recentId);
                var vendor = model.IsVendor;
                if (vendor)
                {
                    if (recentDataDetails != null)
                    {
                        var vendorData = new VendorDetail
                        {
                            AssetID = recentId.ToString(),
                            ProductID = recentDataDetails.ProductId,
                            CostDetails = model.Cost
                        };
                        _bview.VendorDetails.Add(vendorData);
                    }

                    _bview.SaveChanges();
                }
                //AssetAssignedUser table
                var user = new AssetAssignedUser
                {
                    Asset_Id = recentId,
                    UserId = model.AssignedUser != null && model.AssignedUser != "0" ? Convert.ToInt32(model.AssignedUser) : (int?)null,
                    AssignedDate = model.ApprovedDateTime,
                    CreatedDate = DateTime.Now
                };
                _bview.AssetAssignedUsers.Add(user);
                _bview.SaveChanges();
                var result1 = new BusinessViewJsonResult
                {
                    Success = true,
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add New Asset", "Asset Management Api"));

                return JsonConvert.SerializeObject(result1);
            }

            var businessViewJsonResult = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add New Asset", "Asset Management Api"));
            return JsonConvert.SerializeObject(businessViewJsonResult);
        }

        //product names list
        [HttpGet]
        public List<ProductNameModel> Productlist()
        {
            using (var entities = new BViewEntities())
            {
                var list = new List<ProductNameModel>();

                var details = entities.ProductNames.ToList();

                foreach (var detail in details)
                {
                    var model = new ProductNameModel
                    {
                        Name = detail.Name,
                    };

                    list.Add(model);
                }
                return list;
            }
        }

        [HttpGet]
        public List<AssetViewModel> GetAllAssets()
        {
            return _assetManagementService.GetAllAssets(string.Empty, string.Empty,0);
        }

        [HttpPost]
        public string SaveLocation(LocationModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveLocation", "Asset Management Api"));

            if (ModelState.IsValid)
            {
                var location = new LocationTable
                {
                    BranchId = model.BranchId,
                    SeatCode = model.SeatCode,
                    Description = model.Description,
                    Comment = model.Comment
                };
                _bview.LocationTables.Add(location);
                _bview.SaveChanges();
                var result1 = new BusinessViewJsonResult
                {
                    Success = true,
                };
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SaveLocation", "Asset Management Api"));

                return JsonConvert.SerializeObject(result1);
            }

            var businessViewJsonResult = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SaveLocation", "Asset Management Api"));
            return JsonConvert.SerializeObject(businessViewJsonResult);
        }

        [HttpGet]
        public List<LocationModel> GetAllLocations()
        {
            using (var entities = new BViewEntities())
            {
                var list = new List<LocationModel>();

                var details = entities.LocationTables.ToList();

                foreach (var detail in details)
                {
                    var branchName = entities.Branches.FirstOrDefault(x => x.Id == detail.BranchId);
                    var model = new LocationModel
                    {
                        Id = detail.Id,
                        BranchId = detail.BranchId,
                        Branch = branchName?.BranchName,
                        SeatCode = detail.SeatCode,
                        Description = detail.Description,
                        Comment = detail.Comment,
                    };

                    list.Add(model);
                }
                return list;
            }
        }

        [HttpGet]
        public List<SupplierModel> GetAllSuppliers()
        {
            using (var entities = new BViewEntities())
            {
                var list = new List<SupplierModel>();

                var details = entities.Suppliers.ToList();

                foreach (var model in details)
                {
                    var supplierModel = new SupplierModel
                    {
                        SupplierId = model.SupplierId,
                        SupplierName = model.SupplierName,
                        CreatedDate = model.CreatedDate,
                        CreatedDateValue = model.CreatedDate?.ToString("dd-MMM-yyyy"),
                        CompanyName = model.CompanyName,
                        ContactPerson = model.ContactPerson,
                        ContactPosition = model.ContactPosition,
                        CompanyPhoneNumber = model.CompanyPhoneNumber,
                        ContactPhoneNumber = model.ContactPhoneNumber,
                        VendorIntroducedBy = model.VendorIntroducedBy,
                        StartedWorkingFrom = model.StartedWorkingFrom,
                        StartedWorkingFromValue = model.StartedWorkingFrom?.ToString("dd-MMM-yyyy"),
                    };

                    list.Add(supplierModel);
                }
                return list;
            }
        }

        [HttpDelete]
        public string DeleteLocation(int id)
        {
            using (var entities = new BViewEntities())
            {
                var locationDetails = entities.LocationTables.FirstOrDefault(x => x.Id == id);
                if (locationDetails != null)
                {
                    entities.LocationTables.Remove(locationDetails);
                    entities.SaveChanges();
                    return "Success";
                }
                return "failure";
            }
        }

        [HttpGet]
        public List<AssetAssignedUserModel> GetAssignedAssetsBasedOnUser(int userId)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Assigned Assets Based On User", "AssetManagement Api"));
            var assetsList = _assetManagementService.AssignedToMe(userId);
            return assetsList;
        }
    }
}