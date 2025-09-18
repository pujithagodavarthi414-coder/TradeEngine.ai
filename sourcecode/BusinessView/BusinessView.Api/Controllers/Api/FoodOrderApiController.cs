using BusinessView.Api.Models;
using BusinessView.Common;
using BusinessView.DAL;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;
using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Http;

namespace BusinessView.Api.Controllers.Api
{
    public class FoodOrderApiController : ApiController
    {
        private readonly IFoodOrders _foodOrdersheetServices;
        private readonly IBlobService _blobService;

        public FoodOrderApiController()
        {
            _foodOrdersheetServices = new FoodOrdersService();
            _blobService = new BlobService();
        }
        public List<OrdersDisplayModel> GetOrders()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Orders", "FoodOrder Api"));

            List<OrdersDisplayModel> ordersList;

            try
            {
                ordersList = _foodOrdersheetServices.GetAllOrders();
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get All Orders", "FoodOrder Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Orders", "FoodOrder Api"));

            return ordersList;
        }

        [System.Web.Http.HttpPost]
        public string AddOrder(FoodOrdersModel foodOrderSheet)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Order", "Api"));
            if (ModelState.IsValid)
            {
                _foodOrdersheetServices.AddOrUpdate(foodOrderSheet);

                var result1 = new BusinessViewJsonResult
                {
                    Success = true,
                };
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Order", "Api"));
                return JsonConvert.SerializeObject(result1);
            }
            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState

            };
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Order", "Api"));

            return JsonConvert.SerializeObject(result2);
        }

        public string UpdateOrder(FoodOrdersModel foodOrderSheet)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "update Order", "Api"));
            if (foodOrderSheet.Id > 0)
            {
                if (ModelState.IsValid)
                {
                    _foodOrdersheetServices.AddOrUpdate(foodOrderSheet);

                    var result1 = new BusinessViewJsonResult
                    {
                        Success = true,
                    };
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "update Order", "Api"));
                    return JsonConvert.SerializeObject(result1);
                }
            }
            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState

            };
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Order", "Api"));

            return JsonConvert.SerializeObject(result2);
        }

        public string ClaimExpense()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Claim Expense", "Api"));
            if (ModelState.IsValid)
            {
                var claimExpenseModel = new ClaimExpenseModel();
                var orderId = HttpContext.Current.Request.Form["OrderNo"] != null ? Convert.ToInt32(HttpContext.Current.Request.Form["OrderNo"]) : 0;
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["CreatedDate"]))
                {
                    claimExpenseModel.CreatedDate = HttpContext.Current.Request.Form["CreatedDate"];
                }
                claimExpenseModel.OrderNo = orderId;
                claimExpenseModel.Amount = HttpContext.Current.Request.Form["Amount"] != null && HttpContext.Current.Request.Form["Amount"] != "" ? Convert.ToInt32(HttpContext.Current.Request.Form["Amount"]) : 0;
                claimExpenseModel.Comments = HttpContext.Current.Request.Form["Comments"];
                claimExpenseModel.ApprovedBy = HttpContext.Current.Request.Form["ApprovedBy"];
                claimExpenseModel.ApprovedStatus = HttpContext.Current.Request.Form["ApprovedStatus"];
                if(claimExpenseModel.Amount == 0)
                {
                    ModelState.AddModelError("Amount", "Please enter total amount.");

                    var result = new BusinessViewJsonResult
                    {
                        Success = false,
                        ModelState = ModelState
                    };

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Goal", "Goals Api"));

                    return JsonConvert.SerializeObject(result);
                }
                
                Validate(claimExpenseModel);
                if (!ModelState.IsValid)
                {
                    var result = new BusinessViewJsonResult
                    {
                        Success = false,
                        ModelState = ModelState

                    };
                    return JsonConvert.SerializeObject(result);
                }
                var fileResult = GetFilePath(orderId);
                Validate(fileResult);
                if (!ModelState.IsValid)
                {
                    var result = new BusinessViewJsonResult
                    {
                        Success = false,
                        ModelState = ModelState

                    };
                    return JsonConvert.SerializeObject(result);
                }
                _foodOrdersheetServices.AddAnExpense(claimExpenseModel);

                var result1 = new BusinessViewJsonResult
                {
                    Success = true,
                };
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Claim Expense", "Api"));
                return JsonConvert.SerializeObject(result1);
            }

            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState

            };
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Claim Expense", "Api"));

            return JsonConvert.SerializeObject(result2);
        }

        private string GetFilePath(int orderId)
        {
            try
            {
                LoggingManager.Debug("Entered into SaveFile method of employee api controller");
                var filePath = string.Empty;
                int count = Convert.ToInt32(HttpContext.Current.Request.Form["FileCount"]);
                //if (count == 0)
                //{
                //    ModelState.AddModelError("ReceiptPath", "Please upload receipt.");

                //    var result1 = new BusinessViewJsonResult
                //    {
                //        Success = false,
                //        ModelState = ModelState
                //    };

                //    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get File Path", "Food Orders Api"));

                //    return JsonConvert.SerializeObject(result1);
                //}
                for (int i = 0; i < count; i++)
                {
                    var files = HttpContext.Current.Request.Files["ReceiptPath" + i];
                    if (files != null)
                    {
                        var name = Path.GetFileName(files.FileName);

                        var fileExtension = Path.GetExtension(name);

                        var isValidFile = IsFileTypeValid(fileExtension);
                        if (isValidFile)
                        {
                            filePath = _blobService.UploadFile(files);
                            _foodOrdersheetServices.UploadFoodOrderReceipts(orderId,filePath);
                        }
                        else
                        {
                            ModelState.AddModelError("ReceiptPath", "Receipt was not in correct format.");

                            var result2 = new BusinessViewJsonResult
                            {
                                Success = false,
                                ModelState = ModelState
                            };
                            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get File Path", "Food Orders Api"));
                            return JsonConvert.SerializeObject(result2);
                        }
                    }
                }
                return "success";
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                throw;
            }
        }

        private bool IsFileTypeValid(string fileExtension)
        {
            try
            {
                string[] validExtensions = { ".jpeg", ".jpg", ".gif", ".png", ".JPG", ".GIF", ".PNG" };

                if (validExtensions.Contains(fileExtension))
                {
                    return true;
                }

                return false;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                throw;
            }
        }

        [HttpGet]
        public List<FoodOrderModel> GetIndividualOrders()
        {
            var loggedUserId = User.Identity.GetUserId<int>();
            var foodOrderModel = new List<FoodOrderModel>();

            using (var bViewEntities = new BViewEntities())
            {
                var foodOrdersList = bViewEntities.FoodOrders.ToList();
                foreach (var foodOrder in foodOrdersList)
                {
                    var orderedMembersList = bViewEntities.OrderMembers.Where(x => x.OrderId == foodOrder.Id).ToList();
                    var foodOrders = new FoodOrderModel
                    {
                        FoodItems = foodOrder != null ? foodOrder.NightFoodItem.TrimEnd(',') : null,
                        OrderedDate = foodOrder != null ? foodOrder.CreatedDate?.ToString("dd-MMM-yyyy") : null
                    };
                    string totalMemebers = null;
                    foreach (var members in orderedMembersList)
                    {
                        var userNameDetails = bViewEntities.Users.FirstOrDefault(x => x.Id == members.MemberId);
                        var firstMember = userNameDetails.Name + " " + userNameDetails.SurName;
                        totalMemebers = firstMember + "," + totalMemebers;
                        foodOrders.UserName = totalMemebers;
                    }
                    var foodOrderedMembers = foodOrders.UserName?.TrimEnd(',');
                    foodOrders.UserName = foodOrderedMembers;
                        foodOrderModel.Add(foodOrders);
                }
            }
            return foodOrderModel;
        }

        [HttpGet]
        public List<FoodOrderModel> GetAllOrders()
        {
            var loggedUserId = User.Identity.GetUserId<int>();
            var foodOrderModel = new List<FoodOrderModel>();

            using (var bViewEntities = new BViewEntities())
            {
                var orderMemebersList = bViewEntities.FoodOrderExpenses.ToList();
                foreach (var orderMemebers in orderMemebersList)
                {
                    var totalMembers = bViewEntities.OrderMembers.Where(x => x.OrderId == orderMemebers.Id).ToList();
                    var orderedDate = bViewEntities.FoodOrders.Where(x => x.Id == orderMemebers.Id).FirstOrDefault();
                    var foodOrders = new FoodOrderModel
                    {
                        UserCount = totalMembers.Count(),
                        OrderedDate = orderedDate != null ? orderedDate.CreatedDate?.ToString("dd-MMM-yyyy") : null,
                        Amount = orderMemebers.Amount,
                        ApprovedDate = orderMemebers.ApprovedOn?.ToString("dd-MMM-yyyy"),
                        OrderStatus = orderMemebers.ApprovedStatus
                    };
                    foodOrderModel.Add(foodOrders);
                }
            }
            return foodOrderModel;
        }

        [HttpGet]
        public string SearchByMember(string searchByItem)
        {
            using (var entities = new BViewEntities())
            {
                string searchString = !string.IsNullOrEmpty(searchByItem) && !string.IsNullOrWhiteSpace(searchByItem) ? searchByItem.Trim().ToLower() : string.Empty;
                var userNames = entities.Users.Where(x => x.Name.Contains(searchString)).ToList();
                var result = userNames.Select(x => new { value = x.Name + " " + x.SurName }).Where(x => searchString != null && x.value.ToLower().Contains(searchString)).Take(10).ToList();
                return JsonConvert.SerializeObject(result);
            }
        }
    }
}
