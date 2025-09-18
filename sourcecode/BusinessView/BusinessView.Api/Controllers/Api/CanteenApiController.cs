using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Web.Http;
using BusinessView.Common;
using BusinessView.DAL;
using BusinessView.Models;
using Microsoft.AspNet.Identity;

namespace BusinessView.Api.Controllers.Api
{
    public class CanteenApiController : ApiController
    {
        public List<CanteenDetailModel> Get()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Canteen Details", "Canteen Api"));

            var loggedUserId = User.Identity.GetUserId<int>();
            List<CanteenDetailModel> canteenDetailList = new List<CanteenDetailModel>();
            using (BViewEntities bViewEntities = new BViewEntities())
            {
                var canteenDetails = bViewEntities.Usp_GetCanteenDashboard(loggedUserId).ToList();
                foreach (var canteendetail in canteenDetails)
                {
                    CanteenDetailModel canteenDetail = new CanteenDetailModel
                    {
                        UserId = canteendetail.UserId,
                        UserName = canteendetail.UserName,
                        TotalAmount = canteendetail.TotalAmount
                    };
                    canteenDetailList.Add(canteenDetail);
                }
            }
            return canteenDetailList;
        }

        [HttpPost]
        public void UpdateLastDeductedDate(int? userId)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Canteen Detail", "Canteen Api"));

            using (BViewEntities bViewEntities = new BViewEntities())
            {
                var canteenDetails = bViewEntities.CanteenDeductions.FirstOrDefault(x => x.UserId == userId);
                if (canteenDetails != null)
                {
                    canteenDetails.LastDeductedDate = DateTime.Now;
                    bViewEntities.CanteenDeductions.AddOrUpdate(canteenDetails);
                    bViewEntities.SaveChanges();
                }
                else
                {
                    CanteenDeduction canteenDeduction = new CanteenDeduction
                    {
                        UserId = userId,
                        LastDeductedDate = DateTime.Now
                    };
                    bViewEntities.CanteenDeductions.Add(canteenDeduction);
                    bViewEntities.SaveChanges();
                }
            }
        }

        [HttpGet]
        public List<CanteenUserDetailModel> GetUserCanteenDetail(int? userId)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Canteen details based on user", "Canteen Api"));

            if (userId == null)
            {
                userId = User.Identity.GetUserId<int>();
            }

            var canteenDetailList = new List<CanteenUserDetailModel>();

            using (var bViewEntities = new BViewEntities())
            {
                var canteenDetails = bViewEntities.EmployeeFoodRecords.Where(x => x.UserId == userId).ToList();

                foreach (var canteendetail in canteenDetails)
                {
                    var canteenDetail = new CanteenUserDetailModel
                    {
                        UserId = canteendetail.UserId,
                        Item = canteendetail.ItemName,
                        ItemPrice = canteendetail.ItemPrice,
                        PurchasedDate = canteendetail.PurchasedDate?.ToString("dd MMM yyyy")
                    };
                    canteenDetailList.Add(canteenDetail);
                }
            }
            return canteenDetailList;
        }
    }
}