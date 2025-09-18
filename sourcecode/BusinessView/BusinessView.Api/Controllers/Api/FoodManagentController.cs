using BusinessView.Api.Models;
using BusinessView.Api.Models.FoodManagementModel;
using BusinessView.Api.Models.OffersModel;
using BusinessView.Common;
using BusinessView.DAL;
using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using BusinessView.Services;
using BusinessView.Services.Interfaces;
using System.Web;

namespace BusinessView.Api.Controllers.Api
{
    public class FoodManagentController : ApiController
    {
        private readonly IUserService _userService;

        public FoodManagentController()
        {
            _userService = new UserService();
        }

        [HttpPost]
        [ActionName("SaveFoodRecordsOfEmployee")]
        [Authorize]
        public async Task<bool> SaveFoodRecordsOfEmployee(List<FoodRecordsDto> itemDetails)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    foreach (var foodDetails in itemDetails)
                    {
                        var PastFooddetails = await entities.EmployeeFoodRecords.Where(x => x.Id == foodDetails.Id).FirstOrDefaultAsync();

                        if (PastFooddetails == null)
                        {
                            var foodDetailsOfEmployee = new EmployeeFoodRecord
                            {
                                UserId = foodDetails.UserId,
                                CreatedBy = foodDetails.UserId,
                                CreatedOn = DateTime.UtcNow,
                                ItemName = foodDetails.ItemName,
                                ItemPrice = foodDetails.ItemPrice,
                                PurchasedDate = foodDetails.PurchasedDate,
                                IsCredited = false
                            };
                            entities.EmployeeFoodRecords.Add(foodDetailsOfEmployee);
                            entities.SaveChanges();
                        }
                    }
                    return true;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
                return false;
            }
        }

        public DateTime? ConvertFromUTCtoLocal(DateTime? time, int? timeZoneId)
        {
            if (time != null)
            {
                using (BViewEntities entities = new BViewEntities())
                {
                    var localTimeZone = entities.TimeZones.First(x => x.Id == timeZoneId).TimeZone1;
                    TimeZoneInfo timeZone = TimeZoneInfo.FindSystemTimeZoneById(localTimeZone);
                    DateTime utcTime = TimeZoneInfo.ConvertTimeFromUtc(Convert.ToDateTime(time), timeZone);
                    return utcTime;
                }
            }
            return null;
        }

        //[HttpGet]
        //[ActionName("GetAllFoodDetails")]
        //[Authorize]
        //public async Task<List<FoodItemsDto>> GetAllFoodDetails()
        //{
        //    try
        //    {
        //        using (var entities = new BViewEntities())
        //        {
        //            var foodItemsList = new List<FoodItemsDto>();

        //            var itemsList = await entities.FoodItems.Where(x => x.EndDate == null).ToListAsync();

        //            if (itemsList.Count > 0)
        //            {
        //                foreach (var items in itemsList)
        //                {
        //                    var employeeFoodDetails = new FoodItemsDto
        //                    {
        //                        Id = items.Id,
        //                        CreatedBy = items.CreatedBy,
        //                        CreatedOn = items.CreatedOn,
        //                        ItemName = items.ItemName,
        //                        Price = items.Price,
        //                        EndDate = items.EndDate,
        //                        StartDate = items.StartDate
        //                    };

        //                    foodItemsList.Add(employeeFoodDetails);
        //                }
        //                return foodItemsList;
        //            }
        //            return foodItemsList;
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(exception);
        //        return null;
        //    }
        //}

        //[HttpPost]
        //[ActionName("SaveEmployeeFoodPayments")]
        //[Authorize]
        //public async Task<bool> SaveEmployeeFoodPayments(EmployeeDeductionDto employeeDeductionDto)
        //{
        //    try
        //    {
        //        using (var entities = new BViewEntities())
        //        {
        //            decimal? total = new decimal();

        //            var PastFooddetails = await entities.EmployeeDeductions.Where(x => x.Id == employeeDeductionDto.Id).FirstOrDefaultAsync();

        //            if (PastFooddetails == null)
        //            {
        //                var foodPaymentDestailsOfEmployee = new EmployeeDeduction
        //                {
        //                    AdminId = employeeDeductionDto.AdminId,
        //                    Amount = employeeDeductionDto.Amount,
        //                    CretedBy = employeeDeductionDto.UserId,
        //                    CretedOn = DateTime.Now,
        //                    UserId = employeeDeductionDto.UserId
        //                };

        //                entities.EmployeeDeductions.Add(foodPaymentDestailsOfEmployee);

        //                entities.SaveChanges();

        //                var foodRecords = await entities.EmployeeFoodRecords.Where(x => x.UserId == employeeDeductionDto.UserId && x.IsCredited == false).ToListAsync();

        //                foreach (var item in foodRecords)
        //                {
        //                    total = GetTotalOfItems(item.ItemPrice, total == 0 ? Convert.ToDecimal(0) : total);

        //                    if (total <= foodPaymentDestailsOfEmployee.Amount)
        //                    {
        //                        item.IsCredited = true;
        //                    }
        //                    else
        //                    {
        //                        if (item.IsCredited == true)
        //                            item.IsCredited = true;
        //                        else
        //                            item.IsCredited = false;
        //                    }

        //                    entities.EmployeeFoodRecords.AddOrUpdate(item);

        //                    entities.SaveChanges();
        //                }
        //            }
        //            return true;
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(exception);
        //        return false;
        //    }
        //}

        private decimal? GetTotalOfItems(decimal? dishPrice, decimal? Previoustotal)
        {
            if (dishPrice > 0)
            {
                var total = dishPrice + Previoustotal;
                return total;
            }
            return 0;
        }

        //[HttpGet]
        //[ActionName("GetEmployeePaymentDetails")]
        //[Authorize]
        //public async Task<List<EmployeeDeductionDto>> GetEmployeePaymentDetails(int userId)
        //{
        //    var foodPaymentdetailsList = new List<EmployeeDeductionDto>();

        //    try
        //    {
        //        using (var entities = new BViewEntities())
        //        {
        //            var itemsList = await entities.EmployeeDeductions.Where(x => x.UserId == userId).ToListAsync();
        //            if (itemsList.Count > 0)
        //            {
        //                foreach (var items in itemsList)
        //                {
        //                    var employeeFoodPaymentDetails = new EmployeeDeductionDto
        //                    {
        //                        UserId = items.UserId,
        //                        Id = items.Id,
        //                        AdminId = items.AdminId,
        //                        Amount = items.Amount,
        //                        CretedOn = items.CretedOn,
        //                        CretedBy = items.CretedBy
        //                    };
        //                    foodPaymentdetailsList.Add(employeeFoodPaymentDetails);
        //                }
        //                return foodPaymentdetailsList;
        //            }
        //            return foodPaymentdetailsList;
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(exception);

        //        return null;
        //    }
        //}


        //[HttpPost]
        //[ActionName("GetAdminDetailsDetails")]
        //[Authorize]
        //public async Task<Models.ChatModel.UserDto> GetAdminDetailsDetails(int userId)
        //{

        //    try
        //    {
        //        using (var entities = new BViewEntities())
        //        {
        //            var admindetails = await entities.Users.Where(x => x.Id == userId).FirstOrDefaultAsync();
        //            if (admindetails != null)
        //            {
        //                var employeeDetails = new Models.ChatModel.UserDto
        //                {
        //                    Id = admindetails.Id,
        //                    Name = admindetails.Name,
        //                };
        //                return employeeDetails;
        //            }
        //            return new Models.ChatModel.UserDto();
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(exception);
        //        return null;
        //    }
        //}

        //[HttpPost]
        //[ActionName("GetAdminId")]
        //[Authorize]
        //public async Task<Models.ChatModel.UserDto> GetAdminId(string userName)
        //{

        //    try
        //    {
        //        using (var entities = new BViewEntities())
        //        {
        //            var admindetails = await entities.Users.Where(x => x.Name == userName).FirstOrDefaultAsync();
        //            if (admindetails != null)
        //            {
        //                var employeeDetails = new Models.ChatModel.UserDto
        //                {
        //                    Id = admindetails.Id,
        //                    Name = admindetails.Name,
        //                };
        //                return employeeDetails;
        //            }
        //            return new Models.ChatModel.UserDto();
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(exception);
        //        return null;
        //    }
        //}

        //[HttpPost]
        //[ActionName("PayAmountWithOffer")]
        //[Authorize]
        //public async Task<bool> PayAmountWithOffer(OfferPaymentDto offerPaymentDto)
        //{
        //    try
        //    {
        //        using (var entities = new BViewEntities())
        //        {
        //            if (offerPaymentDto != null)
        //            {
        //                var employeeFoodRecords = await entities.EmployeeFoodRecords.Where(x => x.UserId == offerPaymentDto.UserId && x.IsCredited == false).ToListAsync();
        //                if (employeeFoodRecords.Count > 0)
        //                {
        //                    var employeeOfferDetails = await entities.BalanceOffers.Where(x => x.OfferId == offerPaymentDto.OfferId).FirstOrDefaultAsync();
        //                    if (employeeOfferDetails != null)
        //                    {
        //                        if (employeeOfferDetails.BalanceAmount > 0 && employeeOfferDetails.BalanceAmount >= offerPaymentDto.Amount)
        //                        {
        //                            foreach (var foodRecord in employeeFoodRecords)
        //                            {
        //                                if (employeeOfferDetails.BalanceAmount > 0 && employeeOfferDetails.BalanceAmount >= offerPaymentDto.Amount)
        //                                {
        //                                    employeeOfferDetails.BalanceAmount = employeeOfferDetails.BalanceAmount - foodRecord.ItemPrice;

        //                                    offerPaymentDto.Amount = offerPaymentDto.Amount - Convert.ToDecimal(foodRecord.ItemPrice);

        //                                    if (employeeOfferDetails.BalanceAmount >= 0 && offerPaymentDto.Amount >= 0)
        //                                    {
        //                                        var adminDetails = await entities.Users.Where(x => x.Name == offerPaymentDto.AdminName).FirstOrDefaultAsync();

        //                                        if (adminDetails != null)
        //                                        {
        //                                            var employeeFoodDeductions = new EmployeeDeduction
        //                                            {
        //                                                AdminId = adminDetails.Id,
        //                                                Amount = foodRecord.ItemPrice,
        //                                                CretedBy = offerPaymentDto.UserId,
        //                                                CretedOn = DateTime.Now,
        //                                                UserId = offerPaymentDto.UserId
        //                                            };

        //                                            entities.EmployeeDeductions.Add(employeeFoodDeductions);
        //                                            entities.SaveChanges();

        //                                            foodRecord.IsCredited = true;
        //                                            entities.EmployeeFoodRecords.AddOrUpdate(foodRecord);
        //                                            entities.SaveChanges();

        //                                            entities.BalanceOffers.AddOrUpdate(employeeOfferDetails);
        //                                            entities.SaveChanges();

        //                                            if (employeeOfferDetails.BalanceAmount == 0)
        //                                            {
        //                                                var employeeOffer = await entities.Offers.Where(x => x.Id == employeeOfferDetails.OfferId).FirstOrDefaultAsync();

        //                                                if (employeeOffer != null)
        //                                                {
        //                                                    employeeOffer.IsOfferApplicable = false;

        //                                                    entities.Offers.AddOrUpdate(employeeOffer);

        //                                                    entities.SaveChanges();
        //                                                }
        //                                            }
        //                                        }
        //                                    }
        //                                }
        //                            }
        //                            return true;
        //                        }
        //                        return false;
        //                    }
        //                }
        //                return false;
        //            }
        //            return false;
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(exception);
        //        return false;
        //    }
        //}


        [HttpPost]
        public string AmountCreditedByAdmin(OfferPaymentDto model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    using (var entities = new BViewEntities())
                    {
                        var loggedUserId = User.Identity.GetUserId<int>();
                        if (model.IsCreditedByAdmin == 1)
                        {
                            var userId = loggedUserId.ToString();
                            var userIds = model.UserIds?.ToList();
                            if (userIds != null && userIds.Any())
                            {
                                if (userIds[0] != null)
                                {
                                    var selectedUserIds = userIds;

                                    foreach (var selectedUserId in selectedUserIds)
                                    {
                                        var userSelectedId = Convert.ToInt32(selectedUserId);
                                        var creditedOffer = new Offer
                                        {
                                            AdminId = loggedUserId,
                                            EmployeeId = userSelectedId,
                                            OfferAmount = model.CreditedAmount,
                                            IsOfferApplicable = true,
                                            CreatedOn = DateTime.UtcNow
                                        };
                                        entities.Offers.Add(creditedOffer);
                                        var alreadyHaveBalance = entities.UserBalanceCredits.FirstOrDefault(x => x.UserId == userSelectedId);
                                        if (alreadyHaveBalance == null)
                                        {
                                            NewCredit(userSelectedId, model.CreditedAmount);
                                        }
                                        else
                                        {
                                            alreadyHaveBalance.BalanceCredit = alreadyHaveBalance.BalanceCredit + model.CreditedAmount;
                                            alreadyHaveBalance.CreditedOn = DateTime.UtcNow;
                                        }
                                        entities.SaveChanges();
                                    }
                                }
                                else
                                {
                                    ModelState.AddModelError("", "Select User to credit the amount");
                                    var errorResult = new BusinessViewJsonResult
                                    {
                                        Success = false,
                                        ModelState = ModelState
                                    };

                                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Amount Credited By Admin", "Food Managent"));

                                    return JsonConvert.SerializeObject(errorResult);
                                }
                            }
                        }
                        else
                        {
                            var alreadyHaveBalance = entities.UserBalanceCredits.FirstOrDefault(x => x.UserId == loggedUserId);
                            if (alreadyHaveBalance == null)
                            {
                                NewCredit(loggedUserId, model.CreditedAmount);
                            }
                            else
                            {
                                alreadyHaveBalance.BalanceCredit = alreadyHaveBalance.BalanceCredit + model.CreditedAmount;
                                alreadyHaveBalance.CreditedOn = DateTime.UtcNow;
                            }
                            entities.SaveChanges();
                        }
                        decimal? balanceCredit = _userService.GetBalanceCanteenCredit(loggedUserId);

                        var result1 = new BusinessViewJsonResult
                        {
                            Success = true,
                            Data = balanceCredit
                        };

                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Amount Credited By Admin", "Food Managent"));

                        return JsonConvert.SerializeObject(result1);
                    }
                }
                var result2 = new BusinessViewJsonResult
                {
                    Success = false,
                    ModelState = ModelState
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Amount Credited By Admin", "Food Managent"));

                return JsonConvert.SerializeObject(result2);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return "fail";
            }
        }

        public void NewCredit(int userId, decimal creditAmount)
        {
            using (var entities = new BViewEntities())
            {
                var newCredit = new UserBalanceCredit
                {
                    UserId = userId,
                    BalanceCredit = creditAmount,
                    CreditedOn = DateTime.UtcNow
                };
                entities.UserBalanceCredits.Add(newCredit);
                entities.SaveChanges();
            }
        }

        [HttpGet]
        public string SearchByItem(string searchByItem)
        {
            using (var entities = new BViewEntities())
            {
                string searchString = !string.IsNullOrEmpty(searchByItem) && !string.IsNullOrWhiteSpace(searchByItem) ? searchByItem.Trim().ToLower() : string.Empty;
                var foodItems = entities.FoodItems.Where(x => x.ItemName.StartsWith(searchString)).ToList();
                var result = foodItems.Select(x => new { value = x.ItemName }).Where(x => searchString != null && x.value.ToLower().StartsWith(searchString)).Take(10).ToList();
                return JsonConvert.SerializeObject(result);
            }
        }

        [HttpPost]
        public string SaveCanteenPurchasedItem()
        {
            try
            {
                int count = Convert.ToInt32(HttpContext.Current.Request.Form["Count"]);

                if (count > 0)
                {
                    using (var entities = new BViewEntities())
                    {
                        decimal? itemPrice = 0;
                        var loggedUserId = User.Identity.GetUserId<int>();

                        for (int i = 0; i < count; i++)
                        {
                            var foodItem = "";
                            if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["FoodItemsList" + i]))
                            {
                                foodItem = HttpContext.Current.Request.Form["FoodItemsList" + i];
                            }

                            var foodItemsCount = 1;
                            if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["FoodItemsCount" + i]))
                            {
                                foodItemsCount = ConversionHelper.ConvertToInt32(HttpContext.Current.Request.Form["FoodItemsCount" + i]);
                            }
                            else
                            {
                                foodItemsCount = 1;
                            }

                            foodItem = foodItem.Trim().ToLower();

                            var foodDetails = entities.FoodItems.Where(x => x.ItemName.ToLower() == foodItem).FirstOrDefault();
                            if (foodDetails != null)
                            {
                                var foodDetailsOfEmployee = new EmployeeFoodRecord
                                {
                                    UserId = loggedUserId,
                                    CreatedBy = loggedUserId,
                                    CreatedOn = DateTime.UtcNow,
                                    ItemName = foodDetails.ItemName,
                                    ItemCount = foodItemsCount,
                                    ItemPrice = foodDetails.Price,
                                    PurchasedDate = DateTime.UtcNow,
                                    IsCredited = false
                                };

                                itemPrice = itemPrice + (foodItemsCount * foodDetails.Price);
                                entities.EmployeeFoodRecords.Add(foodDetailsOfEmployee);
                            }
                        }

                        var balanceAmountDetails = entities.UserBalanceCredits.FirstOrDefault(x => x.UserId == loggedUserId);
                        if (balanceAmountDetails != null)
                        {
                            if (itemPrice <= balanceAmountDetails.BalanceCredit)
                            {
                                balanceAmountDetails.BalanceCredit = balanceAmountDetails.BalanceCredit - itemPrice;
                                entities.SaveChanges();
                            }
                            else
                            {
                                ModelState.AddModelError("", "Sorry!You don't have enough credit to purchase this item.");
                                var result2 = new BusinessViewJsonResult
                                {
                                    Success = false,
                                    ModelState = ModelState
                                };
                                return JsonConvert.SerializeObject(result2);
                            }
                        }
                        else
                        {
                            ModelState.AddModelError("", "Sorry!You don't have enough credit to purchase this item.");
                            var result2 = new BusinessViewJsonResult
                            {
                                Success = false,
                                ModelState = ModelState
                            };
                            return JsonConvert.SerializeObject(result2);
                        }

                        decimal? balanceCredit = _userService.GetBalanceCanteenCredit(loggedUserId);

                        var result = new BusinessViewJsonResult
                        {
                            Success = true,
                            Data = balanceCredit
                        };

                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Save Canteen Purchased Item", "Food Managent"));

                        return JsonConvert.SerializeObject(result);
                    }
                }
                else
                {
                    ModelState.Remove("itemDetails");
                    ModelState.Remove("itemDetails.String");
                    ModelState.AddModelError("", "Please add fooditem.");
                    var result2 = new BusinessViewJsonResult
                    {
                        Success = false,
                        ModelState = ModelState
                    };
                    return JsonConvert.SerializeObject(result2);
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Save Canteen Purchased Item", "Food Managent", ex.Message));

                throw;
            }
        }

        [HttpPost]
        [Authorize]
        public string AddNewFoodItem(NewFoodItem model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add New FoodItem", "Food Managent"));

            try
            {
                if (ModelState.IsValid)
                {
                    var loggedUserId = User.Identity.GetUserId<int>();

                    using (var entities = new BViewEntities())
                    {
                        var itemName = model.FoodItemName.Trim().ToLower();
                        var foodItemList = entities.FoodItems.FirstOrDefault(x => x.ItemName.ToLower() == itemName && x.Price == model.FoodItemPrice);
                        if (foodItemList == null)
                        {
                            var newFoodItem = new FoodItem
                            {
                                ItemName = model.FoodItemName,
                                Price = model.FoodItemPrice,
                                StartDate = DateTime.UtcNow,
                                CreatedOn = DateTime.UtcNow,
                                CreatedBy = loggedUserId
                            };
                            entities.FoodItems.Add(newFoodItem);
                            entities.SaveChanges();

                            var result1 = new BusinessViewJsonResult
                            {
                                Success = true,
                            };
                            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add New FoodItem", "Food Managent"));
                            return JsonConvert.SerializeObject(result1);
                        }
                        else
                        {
                            ModelState.AddModelError("", "This item was already in the list.");
                            var result2 = new BusinessViewJsonResult
                            {
                                Success = false,
                                ModelState = ModelState
                            };
                            return JsonConvert.SerializeObject(result2);
                        }
                    }
                }
                var result = new BusinessViewJsonResult
                {
                    Success = false,
                    ModelState = ModelState
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add New FoodItem", "Food Managent"));

                return JsonConvert.SerializeObject(result);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Add New FoodItem", "Food Managent", ex.Message));
                throw;
            }
        }

        [HttpGet]
        [ActionName("GetEmployeeFoodDetails")]
        [Authorize]
        public async Task<List<FoodRecordsDto>> GetEmployeeFoodDetails(int userId)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    var fooddetailsList = new List<FoodRecordsDto>();

                    var loggedUserId = User.Identity.GetUserId<int>();
                    var timeZoneId = entities.Users.FirstOrDefault(x => x.Id == loggedUserId).TimeZoneId;

                    var itemsList = new List<EmployeeFoodRecord>();
                    var userDetails = entities.Users.FirstOrDefault(x => x.Id == userId);

                    var isAdmin = userDetails?.IsAdmin;

                    if (isAdmin == true)
                    {
                        itemsList = await entities.EmployeeFoodRecords.OrderByDescending(x => x.PurchasedDate).ToListAsync();
                    }
                    else
                    {
                        itemsList = await entities.EmployeeFoodRecords.Where(x => x.UserId == userId).OrderByDescending(x => x.PurchasedDate).ToListAsync();
                    }

                    if (itemsList.Count > 0)
                    {
                        foreach (var items in itemsList)
                        {
                            var employeeFoodDetails = new FoodRecordsDto
                            {
                                UserId = items.UserId,
                                UserName = items.UserId > 0 ? items.User.Name + " " + items.User.SurName : null,
                                Id = items.Id,
                                CreatedBy = items.CreatedBy,
                                CreatedOn = items.CreatedOn,
                                ItemName = items.ItemName,
                                ItemPrice = items.ItemPrice,
                                ItemCount = items.ItemCount,
                                PurchasedDate = items.PurchasedDate,
                                DateOfPurchase = items.PurchasedDate != null ? ConvertFromUTCtoLocal(items.PurchasedDate, timeZoneId).Value.ToString("dd-MMM-yyyy HH:mm") : null,
                                IsCredited = items.IsCredited
                            };
                            fooddetailsList.Add(employeeFoodDetails);
                        }
                    }
                    return fooddetailsList;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
                return null;
            }
        }

        [HttpGet]
        [Authorize]
        public List<FoodRecordsDto> GetRecentCreditedListByAdmin(int userId)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    var offerDetailsList = new List<FoodRecordsDto>();

                    var loggedUserId = User.Identity.GetUserId<int>();
                    var timeZoneId = entities.Users.FirstOrDefault(x => x.Id == loggedUserId).TimeZoneId;

                    var userDetails = entities.Users.FirstOrDefault(x => x.Id == userId);
                    var isAdmin = userDetails?.IsAdmin;

                    var itemsList = new List<Offer>();
                    if (isAdmin == true)
                    {
                        itemsList = entities.Offers.OrderByDescending(x => x.CreatedOn).ToList();
                    }
                    else
                    {
                        itemsList = entities.Offers.Where(x => x.EmployeeId == userId).OrderByDescending(x => x.CreatedOn).ToList();
                    }

                    if (itemsList.Count > 0)
                    {
                        foreach (var items in itemsList)
                        {
                            var employeeOfferDetails = new FoodRecordsDto
                            {
                                UserId = items.EmployeeId,
                                AddedBy = items.AdminId != 0 ? items.User.Name + " " + items.User.SurName : null,
                                UserName = items.EmployeeId != 0 ? items.User1.Name + " " + items.User1.SurName : null,
                                CreditedDate = items.CreatedOn != null ? ConvertFromUTCtoLocal(items.CreatedOn, timeZoneId).Value.ToString("dd-MMM-yyyy HH:mm") : null,
                                OfferAmount = items.OfferAmount,
                            };
                            offerDetailsList.Add(employeeOfferDetails);
                        }
                    }
                    return offerDetailsList;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return null;
            }
        }

        [HttpGet]
        [Authorize]
        public List<FoodRecordsDto> GetFoodItemsLIst()
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    var itemDetailsList = new List<FoodRecordsDto>();

                    var loggedUserId = User.Identity.GetUserId<int>();
                    var timeZoneId = entities.Users.FirstOrDefault(x => x.Id == loggedUserId).TimeZoneId;

                    var itemsList = entities.FoodItems.OrderByDescending(x => x.CreatedOn).ToList();
                    if (itemsList.Count > 0)
                    {
                        foreach (var items in itemsList)
                        {
                            var foodItemDetails = new FoodRecordsDto
                            {
                                ItemName = items.ItemName,
                                AddedOn = items.CreatedOn != null ? ConvertFromUTCtoLocal(items.CreatedOn, timeZoneId).Value.ToString("dd-MMM-yyyy HH:mm") : null,
                                ItemPrice = items.Price,
                            };
                            itemDetailsList.Add(foodItemDetails);
                        }
                    }
                    return itemDetailsList;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
                return null;
            }
        }

        [HttpGet]
        [Authorize]
        public List<CanteenBalanceModel> GetBalanceDetails(int userId)
        {
            try
            {
                using (var entities = new BViewEntities())
                {
                    var balanceDetailsList = new List<CanteenBalanceModel>();

                    var loggedUserId = User.Identity.GetUserId<int>();

                    var balanceList = entities.USP_GetEmployeeCredit(loggedUserId).ToList();

                    if (balanceList.Count > 0)
                    {
                        foreach (var item in balanceList)
                        {
                            var balanceDetails = new CanteenBalanceModel
                            {
                                UserName = item.FullName,
                                CreditedAmount = item.CreditedAmount != null ? item.CreditedAmount.ToString() : null,
                                AmountDebited = item.AmountDebited != null ? item.AmountDebited.ToString() : null,
                                AmountRemaining = (item.AmountRemaining != null && item.AmountRemaining != 0) ? item.AmountRemaining.ToString() : null
                            };
                            balanceDetailsList.Add(balanceDetails);
                        }
                    }
                    return balanceDetailsList;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return null;
            }
        }
    }
}