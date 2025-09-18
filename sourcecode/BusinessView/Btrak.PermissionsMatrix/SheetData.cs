using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Threading;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Services;
using Google.Apis.Sheets.v4;
using Google.Apis.Sheets.v4.Data;
using Google.Apis.Util.Store;
using Snovasys.ActivityWatcher.Common;

namespace Btrak.PermissionsMatrix
{
    public class SheetData
    {
        public static List<object> GetSheetData(string range)
        {
            return Retry.Do(() => GetSheetDataInternal(range), TimeSpan.FromSeconds(5), 10);
        }

        private static List<object> GetSheetDataInternal(string range)
        {
            UserCredential credential;
            string[] scopes = {SheetsService.Scope.SpreadsheetsReadonly};
            string ApplicationName = "Google Sheets API .NET Quickstart";
            var path = @"..\..\Credentials.json";
            using (var stream =
                new FileStream(path, FileMode.Open, FileAccess.Read))
            {
                // The file token.json stores the user's access and refresh tokens, and is created
                // automatically when the authorization flow completes for the first time.
                string credPath = @"..\..\token.json";
                credential = GoogleWebAuthorizationBroker.AuthorizeAsync(
                    GoogleClientSecrets.Load(stream).Secrets,
                    scopes,
                    "user",
                    CancellationToken.None,
                    new FileDataStore(credPath, true)).Result;
                Console.WriteLine("Google sheet authorization done and token saved in token.json");
            }

            // Create Google Sheets API service.
            SheetsService service = new SheetsService(new BaseClientService.Initializer
            {
                HttpClientInitializer = credential,
                ApplicationName = ApplicationName,
            });

            // Define request parameters.
            string spreadsheetId = ConfigurationManager.AppSettings["SpreadSheetId"];
            SpreadsheetsResource.ValuesResource.GetRequest request =
                service.Spreadsheets.Values.Get(spreadsheetId, range);

            // Prints the names and majors of students in a sample spreadsheet:
            // https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
            ValueRange response = request.Execute();
            Console.WriteLine("Data retrieved from PermissionsMatrix sheet");
            IList<IList<Object>> values = response.Values;
            var listOfStrings = new List<Object>();

            var features = values[0];
            Console.WriteLine("Processing data.... with features count as: " + features.Count);
            for (var i = 1; i < features.Count; i++)
            {
                Console.WriteLine("count = " + values.Count + ", no's = " +
                                  values.Count(x => x[i].ToString().ToLower() == "yes") + ", yes's = " +
                                  values.Count(x => x[i].ToString().ToLower() == "yes"));
                var rootActions = values.Where(x => x[i].ToString().ToLower() == "yes").Select(x => x[0]).ToList();
                if (rootActions.Count > 0)
                {
                    listOfStrings.Add(features[i].ToString());
                    listOfStrings.AddRange(rootActions);
                }
            }

            Console.WriteLine("Data processing completed and returned " + listOfStrings.Count);

            if (listOfStrings.Count == 0)
            {
                Console.WriteLine("Unable to read the data from the sheet.. may be sheet is initializing... ");

                throw new Exception("Unable to read the data from the sheet.. may be sheet is initializing...");
            }

            return listOfStrings;
        }
    }
}