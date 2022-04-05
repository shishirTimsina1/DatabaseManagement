//Shishir Timsina SHT99
//Chris Votilla CMV43
//CS1555 HW5
import java.util.InputMismatchException;
import java.util.Properties;
import java.sql.*;
import java.util.Scanner;
import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime;  


public class team01
{
    static Scanner user = new Scanner(System.in);
    static Connection conn;

    public static void main(String args[]) throws SQLException, ClassNotFoundException
    {
        Class.forName("org.postgresql.Driver");
        String url = "jdbc:postgresql://localhost:5432/";
        Properties props = new Properties();
        props.setProperty("user", "postgres");
        props.setProperty("password", "pass");
        conn = DriverManager.getConnection(url, props);

        displayMenu();
    }

    public static void displayMenu()
    {
        System.out.println("Welcome to the CS1555 Forest Registry Interface!");
        System.out.println("Please select one of the below options [1-9]:");
        System.out.println("1: Add Forest");
        System.out.println("2: Add Worker");
        System.out.println("3: Add Sensor");
        System.out.println("4: Switch Workers Duties");
        System.out.println("5: Update Sensor Status");
        System.out.println("6: Update Forest Covered Area");
        System.out.println("7: Find Top-k Busy Workers");
        System.out.println("8: Display Sensors Ranking");
        System.out.println("9: Exit");
        System.out.print("Your selection: ");

        String selection = user.nextLine();
        switch(selection)
        {
            case "1":
            {
                addForest();
                break;
            }
            case "2":
            {
                addWorker();
                break;
            }
            case "3":
            {
                addSensor();
                break;
            }
            case "4":
            {
                switchDuties();
                break;
            }
            case "5":
            {
                updateSensor();
                break;
            }
            case "6":
            {
                updateCovered();
                break;
            }
            case "7":
            {
                busyWorkers();
                break;
            }
            case "8":
            {
                sensorRanking();
                break;
            }
            case "9":
            {
                user.close();
                System.exit(0);
            }
            default:
            {
                invalidInput();
                break;
            }
        }
    }

    public static void addForest() //1
    { 
        System.out.println();
        System.out.println("Welcome to add forest!");
        // signature of the proc to add a forest is addForest(newName varchar(30), newArea real, 
            // newAcidLevel real, newXmin real, newXmax real, newYmin real, newYmax real)

        try
        {
        // ex: CallableStatement properCase = conn.prepareCall("{ ? = call can_pay_loan( ? ) }");
        CallableStatement addForestStatement = conn.prepareCall("{ ? = call addForest(? , ? , ? , ? , ? , ? , ?) }");

        //variables that will be filled by the user after testing
        System.out.print("Enter a name for the forest: ");
        String newName = user.nextLine();
        if(newName.length() > 30 || newName.length() == 0)
            throw new InputMismatchException();

        System.out.print("Enter an area for the forest: ");
        float newArea = user.nextFloat();
        user.nextLine(); //read the rest of the line not read by next float

        System.out.print("Enter an acid level for the forest[0.0-0.99999]: ");
        float newAcidLevel = user.nextFloat();
        user.nextLine();

        System.out.print("Enter an Xmin for the forest: ");
        float newXmin = user.nextFloat();
        user.nextLine();

        System.out.print("Enter an Xmax for the forest: ");
        float newXmax = user.nextFloat();
        user.nextLine();

        System.out.print("Enter a Ymin for the forest: ");
        float newYmin = user.nextFloat();
        user.nextLine();

        System.out.print("Enter a Ymax for the forest: ");
        float newYmax = user.nextFloat();
        user.nextLine();

        String rReturn;

        addForestStatement.registerOutParameter(1, Types.VARCHAR);
        addForestStatement.setString(2, newName);
        addForestStatement.setFloat(3, newArea);
        addForestStatement.setFloat(4, newAcidLevel);
        addForestStatement.setFloat(5, newXmin);
        addForestStatement.setFloat(6, newXmax);
        addForestStatement.setFloat(7, newYmin);
        addForestStatement.setFloat(8, newYmax);
        addForestStatement.execute();

        rReturn = addForestStatement.getString(1);
        addForestStatement.close();
        System.out.println("Forest number " + rReturn + " was successfully added to the database");

        }
        catch (SQLException e1) 
        {
            System.out.println("SQL Error");
            while (e1 != null) {
                System.out.println("Message = " + e1.getMessage());
                System.out.println("SQLState = "+ e1.getSQLState());
                System.out.println("SQL Code = "+ e1.getErrorCode());
                e1 = e1.getNextException();
            }

            returnToMenu();
        }
        catch(InputMismatchException e2)
        {
            System.out.println("invalid input... Press enter to return to main menu, please try again!");
            System.out.println();

            user.nextLine();
            returnToMenu();
        }
        //user.nextLine();
        returnToMenu();
    }
    public static void addWorker() //2
    {
        System.out.println();
        System.out.println("Welcome to add worker!");
        //Take in: worker SSN, worker name, worker rank, and worker’s employing state abbreviation.
        try
        {
            CallableStatement addWorkerStatement = conn.prepareCall("{ ? = call addWorker(? , ? , ? , ? ) }");

            //get input from user
            System.out.print("Please enter an SSN for the worker (no dashes/spaces): ");
            String newSSN = user.nextLine();
            if(newSSN.length() != 9)
                throw new InputMismatchException();

            System.out.print("Please enter the name of the new worker: ");
            String newName = user.nextLine();
            if(newName.length() == 0 || newName.length() > 30)
                throw new InputMismatchException();
            //make capitilization constant
            newName = newName.substring(0,1).toUpperCase() + newName.substring(1).toLowerCase();

            System.out.print("Please enter a rank for the worker: ");
            int newRank = user.nextInt();
            user.nextLine();

            System.out.print("Please enter the 2-letter abbreviation for the worker's employing state: ");
            String newState = user.nextLine();
            newState = newState.toUpperCase();
            if(newState.length() != 2)
                throw new InputMismatchException();

            String rReturn;
            addWorkerStatement.registerOutParameter(1, Types.VARCHAR);
            addWorkerStatement.setString(2, newSSN);
            addWorkerStatement.setString(3, newName);
            addWorkerStatement.setInt(4, newRank);
            addWorkerStatement.setString(5, newState);
            addWorkerStatement.execute();

            rReturn = addWorkerStatement.getString(1);
            addWorkerStatement.close();
            System.out.println("Successfully added " + rReturn + " to the database");

        }
        catch (SQLException e1) 
        {
            System.out.println("SQL Error");
            while (e1 != null) {
                System.out.println("Message = " + e1.getMessage());
                System.out.println("SQLState = "+ e1.getSQLState());
                System.out.println("SQL Code = "+ e1.getErrorCode());
                e1 = e1.getNextException();
            }
            returnToMenu();
        }
        catch(InputMismatchException e2)
        {
            System.out.println("invalid input... Press enter to return to main menu, please try again!");
            System.out.println();

            user.nextLine();
            returnToMenu();
        }

        //user.nextLine();
        returnToMenu();
    }
    public static void addSensor() //3
    {
        //take in: X coordinate, Y coordinate, last time it was charged, maintainer, last time it generated a report, and energy level
        System.out.println();
        System.out.println("Welcome to add sensor");

        try
        {
            CallableStatement addSensorStatement = conn.prepareCall("{ ? = call addSensor(? , ? , ? , ? , ? , ?) }");

            //start getting input
            System.out.print("Please enter the x coordinate of the new sensor: ");
            float xCoord = user.nextFloat();
            user.nextLine();
            
            System.out.print("Please enter the y coordinate of the new sensor: ");
            float yCoord = user.nextFloat();
            user.nextLine();

            System.out.print("Please enter the year the sensor was last charged: ");
            int cYear = user.nextInt();
            if(cYear < 0)
                throw new InputMismatchException();
            user.nextLine();

            System.out.print("Please enter the month the sensor was last charged (1-12): ");
            int cMonth = user.nextInt();
            if(cMonth < 1 || cMonth > 12)
                throw new InputMismatchException();
            user.nextLine();

            System.out.print("Please enter the day the sensor was last charged (1-31): ");
            int cDay = user.nextInt();
            if(cDay < 1 || cDay > 31)
                throw new InputMismatchException();
            user.nextLine();

            System.out.print("Please enter the hour the sensor was last charged (0-23): ");
            int cHour = user.nextInt();
            if(cHour < 0 || cHour > 23)
                throw new InputMismatchException();
            user.nextLine();

            System.out.print("Please enter the minute the sensor was last charged (0-59): ");
            int cMinute = user.nextInt();
            if(cMinute < 0 || cMinute > 59)
                throw new InputMismatchException();
            user.nextLine();
            String cMinuteString;
            if(cMinute < 10)
                cMinuteString = "0"+cMinute;
            else
                cMinuteString = ""+cMinute;

            String cTime = ""+cMonth+"/"+cDay+"/"+cYear+" "+cHour+":"+cMinuteString;

            System.out.print("Please enter the SSN of the maintainer for the sensor: ");
            String newSSN = user.nextLine();
            if(newSSN.length() != 9)
                throw new InputMismatchException();

            System.out.print("Please enter the year of the sensor's last report: ");
            int rYear = user.nextInt();
            if(rYear < 0)
                throw new InputMismatchException();
            user.nextLine();

            System.out.print("Please enter the month of the sensor's last report (1-12): ");
            int rMonth = user.nextInt();
            if(rMonth < 0 || rMonth > 12)
                throw new InputMismatchException();
            user.nextLine();

            System.out.print("Please enter the day of the sensor's last report (1-31): ");
            int rDay = user.nextInt();
            if(rDay < 0 || rDay > 31)
                throw new InputMismatchException();
            user.nextLine();

            System.out.print("Please enter the hour of the sensor's last report (0-23): ");
            int rHour = user.nextInt();
            if(rHour < 0 || rHour > 23)
                throw new InputMismatchException();
            user.nextLine();

            System.out.print("Please enter the minute of the sensor's last report (0-59): ");
            int rMinute = user.nextInt();
            if(rMinute < 0 || rMinute > 59)
                throw new InputMismatchException();
            user.nextLine();
            String rMinuteString;
            if(rMinute < 10)
                rMinuteString = "0"+rMinute;
            else
                rMinuteString = ""+rMinute;

            String rTime = ""+rMonth+"/"+rDay+"/"+rYear+" "+rHour+":"+rMinuteString;

            System.out.print("Please enter the energy level of the sensor (0-100): ");
            int energyLevel = user.nextInt();
            if(energyLevel < 0 || energyLevel > 100)
                throw new InputMismatchException();
            user.nextLine();

            int rReturn;
            addSensorStatement.registerOutParameter(1, Types.INTEGER);
            addSensorStatement.setFloat(2, xCoord);
            addSensorStatement.setFloat(3, yCoord);
            addSensorStatement.setString(4, cTime);
            addSensorStatement.setString(5, newSSN);
            addSensorStatement.setString(6, rTime);
            addSensorStatement.setInt(7, energyLevel);
            addSensorStatement.execute();
            
            rReturn = addSensorStatement.getInt(1);
            addSensorStatement.close();
            System.out.println("Successfully added sensor " + rReturn + " to the database at x: " + xCoord + " and y: " + yCoord + ".");
        }
        catch (SQLException e1) 
        {
            System.out.println("SQL Error");
            while (e1 != null) {
                System.out.println("Message = " + e1.getMessage());
                System.out.println("SQLState = "+ e1.getSQLState());
                System.out.println("SQL Code = "+ e1.getErrorCode());
                e1 = e1.getNextException();
            }

            returnToMenu();
        }
        catch(InputMismatchException e2)
        {
            System.out.println("invalid input... Press enter to return to main menu, please try again!");
            System.out.println();

            user.nextLine();
            returnToMenu();
        }
        //user.nextLine();
        returnToMenu();
    }
    public static void switchDuties() //4
    {
        System.out.println();
        System.out.println("Welcome to switch duties");

        try
        {
            CallableStatement swapDutiesStatement = conn.prepareCall("{ ? = call swapDuties(? , ? ) }");

            //get input from user
            System.out.print("Please enter the name of the first worker: ");
            String workerA = user.nextLine();
            if(workerA.length() > 30)
                throw new InputMismatchException();
            //make sure no issues with capitilization
            workerA = workerA.substring(0,1).toUpperCase() + workerA.substring(1).toLowerCase();

            System.out.print("Please enter the name of the second worker: ");
            String workerB = user.nextLine();
            if(workerB.length() > 30)
                throw new InputMismatchException();
            workerB = workerB.substring(0,1).toUpperCase() + workerB.substring(1).toLowerCase();

            boolean rReturn;
            swapDutiesStatement.registerOutParameter(1, Types.BIT);
            swapDutiesStatement.setString(2, workerA);
            swapDutiesStatement.setString(3, workerB);
            swapDutiesStatement.execute();

            rReturn = swapDutiesStatement.getBoolean(1);
            swapDutiesStatement.close();
            if(rReturn)
                System.out.println("Successfully swapped "+workerA+"'s and "+workerB+"'s duties.");

        }
        catch (SQLException e1) 
        {
            System.out.println("SQL Error");
            while (e1 != null) {
                System.out.println("Message = " + e1.getMessage());
                System.out.println("SQLState = "+ e1.getSQLState());
                System.out.println("SQL Code = "+ e1.getErrorCode());
                e1 = e1.getNextException();
            }
            returnToMenu();
        }
        catch(InputMismatchException e2)
        {
            System.out.println("invalid input... Press enter to return to main menu, please try again!");
            System.out.println();

            user.nextLine();
            returnToMenu();
        }

        //user.nextLine();
        returnToMenu();
    }
    public static void updateSensor() //5
    {
        System.out.println();
        System.out.println("welcome to update sensor");
        
        try
        {
            CallableStatement updateSensorStatement = conn.prepareCall("{ ? = call updateSensor(? , ? , ? , ? , ? , ?) }");

            //get input from user
            //take in float x coord, float y coord, int energy level, vc30 last charged, int temp, vc30 cur time
            System.out.print("Please enter the x coordinate of the sensor: ");
            float xCoord = user.nextFloat();
            user.nextLine();

            System.out.print("Please enter the y coordinate of the sensor: ");
            float yCoord = user.nextFloat();
            user.nextLine();

            System.out.print("Please enter the energy level of the sensor (0-100): ");
            int energyLevel = user.nextInt();
            user.nextLine();

            System.out.print("Please enter the year that the sensor was last charged: ");
            int year = user.nextInt();
            user.nextLine();

            System.out.print("Please enter the month that the sensor was last charged (1-12): ");
            int month = user.nextInt();
            if(month < 1 || month > 12)
                throw new InputMismatchException();
            user.nextLine();

            System.out.print("Please enter the day that the sensor was last charged (1-31): ");
            int day = user.nextInt();
            if(day < 1 || day > 31)
                throw new InputMismatchException();
            user.nextLine();

            System.out.print("Please enter the hour that the sensor was last charged (0-23): ");
            int hour = user.nextInt();
            if(hour < 0 || hour > 23)
                throw new InputMismatchException();
            user.nextLine();

            System.out.print("Please enter the minute that the sensor was last charged (0-59): ");
            int minute = user.nextInt();
            if(minute < 0 || minute > 59)
                throw new InputMismatchException();
            user.nextLine();

            //format the time string
            String cTime = ""+month+"/"+day+"/"+year+" "+hour+":"+minute;

            System.out.print("Please enter the temperature that the sensor reported: ");
            int temp = user.nextInt();
            user.nextLine();

            //get the current time to throw in the report and last read
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MM/dd/yyyy HH:mm");  
            LocalDateTime now = LocalDateTime.now();  
            String curTime = ""+ dtf.format(now); 

            boolean rReturn; //return true if emergency, false otherwise
            updateSensorStatement.registerOutParameter(1, Types.BIT);
            updateSensorStatement.setFloat(2, xCoord);
            updateSensorStatement.setFloat(3, yCoord);
            updateSensorStatement.setInt(4, energyLevel);
            updateSensorStatement.setString(5, cTime);
            updateSensorStatement.setInt(6, temp);
            updateSensorStatement.setString(7, curTime);
            updateSensorStatement.execute();

            rReturn = updateSensorStatement.getBoolean(1);
            updateSensorStatement.close();
            if(rReturn)
                System.out.println("Updated sensor, an emergency WAS reported.");
            else
                System.out.println("Updated sensor, an emergency WAS NOT reported.");

        }
        catch (SQLException e1) 
        {
            System.out.println("SQL Error");
            while (e1 != null) {
                System.out.println("Message = " + e1.getMessage());
                System.out.println("SQLState = "+ e1.getSQLState());
                System.out.println("SQL Code = "+ e1.getErrorCode());
                e1 = e1.getNextException();
            }
            returnToMenu();
        }
        catch(InputMismatchException e2)
        {
            System.out.println("invalid input... Press enter to return to main menu, please try again!");
            System.out.println();

            user.nextLine();
            returnToMenu();
        }

        //user.nextLine();
        returnToMenu();
    }
    public static void updateCovered() //6
    {
        System.out.println();
        System.out.println("Welcome to update covered");

        //take in: forestName varchar(30), stateName varchar(2), newArea real

        try
        {
            CallableStatement updateCoveredStatement = conn.prepareCall("{ ? = call updateCovered(? , ? , ? ) }");

            //get input from user
            System.out.print("Please enter the name of the forest: ");
            String forestName = user.nextLine();
            if(forestName.length() > 30)
                throw new InputMismatchException();

            System.out.print("Please enter the 2 letter abbreviation of the state: ");
            String stateName = user.nextLine();
            stateName = stateName.toUpperCase();
            if(stateName.length() !=2)
                throw new InputMismatchException();

            System.out.print("Please enter the new area of the forest in the state: ");
            float newArea = user.nextFloat();
            user.nextLine();

            Boolean rReturn;
            updateCoveredStatement.registerOutParameter(1, Types.BIT);
            updateCoveredStatement.setString(2, forestName);
            updateCoveredStatement.setString(3, stateName);
            updateCoveredStatement.setFloat(4, newArea);
            updateCoveredStatement.execute();

            rReturn = updateCoveredStatement.getBoolean(1);
            updateCoveredStatement.close();
            if(rReturn)
            {
                System.out.println("Successfully updated covered area of forest "+forestName+" in "+stateName+ " to "+newArea);
                //System.out.println("Press enter...");
            }    

        }
        catch (SQLException e1) 
        {
            System.out.println("SQL Error");
            while (e1 != null) {
                System.out.println("Message = " + e1.getMessage());
                System.out.println("SQLState = "+ e1.getSQLState());
                System.out.println("SQL Code = "+ e1.getErrorCode());
                e1 = e1.getNextException();
            }
            returnToMenu();
        }
        catch(InputMismatchException e2)
        {
            System.out.println("invalid input... Press enter to return to main menu, please try again!");
            System.out.println();

            user.nextLine();
            returnToMenu();
        }

        //user.nextLine();
        returnToMenu();
    }
    public static void busyWorkers() //7
    {
        System.out.println();
        System.out.println("welcome to top k busy workers");

        try
        {
            CallableStatement busyWorkersStatement = conn.prepareCall("{ ? = call busyWorkers(?) }");

            //get input from user - pass in 1 integer
            System.out.print("Please enter how many of the top busiest workers you want to see: ");
            int num = user.nextInt();
            user.nextLine();
            

            String rReturn;
            busyWorkersStatement.registerOutParameter(1, Types.VARCHAR);
            busyWorkersStatement.setInt(2, num);
            busyWorkersStatement.execute();

            rReturn = busyWorkersStatement.getString(1);
            busyWorkersStatement.close();
        
            //break up the string returned from SQL
            rReturn = rReturn.substring(0, rReturn.length()-1);
            String[] result = rReturn.split(","); //split the string based off of the passed back commas
            //System.out.println("result length: " + result.length);

            int iters = result.length/3; //result length will always be divisible by 3
            System.out.println();
            for(int j = 0 ; j < result.length ; j++)
            {
                    System.out.print(result[j]+": ");
                    j++;
                    System.out.print(result[j]+"     ");
                    j++;
                    System.out.print("sensors to recharge: " + result[j]);
                    System.out.println();
            }
            //System.out.println("press enter...");
        }
        catch (SQLException e1) 
        {
            System.out.println("SQL Error");
            while (e1 != null) {
                System.out.println("Message = " + e1.getMessage());
                System.out.println("SQLState = "+ e1.getSQLState());
                System.out.println("SQL Code = "+ e1.getErrorCode());
                e1 = e1.getNextException();
            }
            returnToMenu();
        }
        catch(InputMismatchException e2)
        {
            System.out.println("invalid input... Press enter to return to main menu, please try again!");
            System.out.println();

            user.nextLine();
            returnToMenu();
        }

        //user.nextLine();
        returnToMenu();
    }
    public static void sensorRanking() //8
    {
        System.out.println();
        System.out.println("welcome to sensor ranking");

        try
        {
            CallableStatement sensorRankingStatement = conn.prepareCall("{ ? = call sensorRanking() }");

            
            

            String rReturn;
            sensorRankingStatement.registerOutParameter(1, Types.VARCHAR);
            sensorRankingStatement.execute();

            rReturn = sensorRankingStatement.getString(1);
            sensorRankingStatement.close();
        
            //break up the string returned from SQL
            if(rReturn.length() == 0)
            {
                System.out.println("There are no sensors in the database");
                returnToMenu();
            }
            rReturn = rReturn.substring(0, rReturn.length()-1);
            String[] result = rReturn.split(","); //split the string based off of the passed back commas
            //System.out.println("result length: " + result.length);

            int iters = result.length/3; //result length will always be divisible by 3
            System.out.println();
            for(int j = 0 ; j < result.length ; j++)
            {
                    System.out.print(result[j]+": ");
                    j++;
                    System.out.print("id: "+result[j]+"     ");
                    j++;
                    System.out.print("number of reports: " + result[j]);
                    System.out.println();
            }
            //System.out.println("press enter...");
        }
        catch (SQLException e1) 
        {
            System.out.println("SQL Error");
            while (e1 != null) {
                System.out.println("Message = " + e1.getMessage());
                System.out.println("SQLState = "+ e1.getSQLState());
                System.out.println("SQL Code = "+ e1.getErrorCode());
                e1 = e1.getNextException();
            }
            returnToMenu();
        }
        catch(InputMismatchException e2)
        {
            System.out.println("invalid input... Press enter to return to main menu, please try again!");
            System.out.println();

            user.nextLine();
            returnToMenu();
        }

        //user.nextLine();
        returnToMenu();
    }
    public static void invalidInput() //default
    {
        System.out.println("Input was invalid, please select an option 1 through 9");

        returnToMenu();
    }
    public static void returnToMenu()
    {
        System.out.println("");
        System.out.println("Press Enter to return to the main menu...");
        user.nextLine();
        displayMenu();
    }
}