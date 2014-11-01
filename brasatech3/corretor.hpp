

using namespace std;

typedef struct point
{
    double x;
    double y;
    int check;
    
} point;

bool ord_Inc_byX(point A, point B)
{
    if (A.x < B.x)
    {
        return true;
    }
    
    return false;
}

bool ord_Dec_byX(point A, point B)
{
    if (A.x > B.x)
    {
        return true;
    }
    
    return false;
}

bool ord_Inc_byY(point A, point B)
{
    if (A.y < B.y)
    {
        return true;
    }
    
    return false;
}

bool ord_Dec_byY(point A, point B)
{
    if (A.y > B.y)
    {
        return true;
    }
    
    return false;
}

// calculate distance from point K to line MN
double dist(point K, point M, point N)
{
    // define points
    double x_0 = K.x;
    double y_0 = K.y;
    double x_1 = M.x;
    double y_1 = M.y;
    double x_2 = N.x;
    double y_2 = N.y;
    
    double answer = 0;
    
    double numerador = 0;
    double denominador = 0;
    
    numerador = fabs((y_1 - y_2)*x_0 + (x_2 - x_1)*y_0 + x_1*y_2 - y_1*x_2);
    
    denominador = sqrt((y_1 - y_2)*(y_1 - y_2) + (x_2 - x_1)*(x_2 - x_1));

    answer = numerador/denominador;

    return answer;
}

vector<bool> readAnswers(vector<point> pts, vector<int> correct_answer, double threshold, int quest, int qty_alt)
{
    
    // define left and right points of answer sheet
    point left[quest + 2];
    point right[quest + 2];
    
    // define top and bottom points of answer sheet
    point top[qty_alt + 2];
    point bottom[qty_alt + 2];
    
    // define answer points
    point answers[quest + 2];
    
    // define vector result
    vector<bool> result;
    
    for (int i = 0; i < pts.size(); i++)
    {
        (pts.at(i)).check = 0;
    }
    
    // find the left points
    
    // sort points increasingly according to x-coordinate
    sort(pts.begin(), pts.end(), ord_Inc_byX);
    
    for (int i = 0; i < quest; i++)
    {
        left[i] = pts.at(i);
        
        // check this point
        pts[i].check = 1;
    }
    
    // find the right points
    
    // sort points decreasingly according to x-coordinate
    sort(pts.begin(), pts.end(), ord_Dec_byX);
    
    for (int i = 0; i < quest; i++)
    {
        right[i] = pts.at(i);
        
        // check this point
        pts[i].check = 1;
    }
    
    // find the bottom points
    
    // sort points decreasingly according to y-coordinate
    sort(pts.begin(), pts.end(), ord_Dec_byY);
    
    for (int i = 0; i < qty_alt; i++)
    {
        bottom[i] = pts.at(i);
        
        // check this point
        pts[i].check = 1;
    }
    
    // find the top points
    
    // sort points increasingly according to y-coordinate
    sort(pts.begin(), pts.end(), ord_Inc_byY);
    
    for (int i = 0; i < qty_alt; i++)
    {
        top[i] = pts.at(i);
        
        // check this point
        pts[i].check = 1;
    }
    
    // find answer points
    for (int i = 0; i < pts.size(); i++)
    {
        // check if it has not been checked before
        if (pts[i].check != 1)
        {
            // if it has not been checked, it is an answer point
            answers[i] = pts.at(i);
        }
    }
    
    // lets check if these bitches are correct answers
    
    // define current answer being checked
    int current_answer = 0;
    
    for (int i = 0; i < quest; i++)
    {
        result.push_back(false);
        
        // check if current answer corresponds to current question
        if (dist(answers[current_answer], left[i], right[i]) <= threshold)
        {
            // check if this is the right answer
            if (dist(answers[current_answer], top[correct_answer[i]], bottom[correct_answer[i]]) <= threshold)
            {
                result.at(i) = true;
            }
            
            // update current_answer being checked
            current_answer++;
        }
    }
    
    return result;
} 

int main()
{

    /*vector<point> input;
    
    vector<int> answers;
    
    double a, b;
    point P;
    
    for (int i = 0; i < 9; i++)
    {
        scanf("%lf %lf", &a, &b);
        P.x = a;
        P.y = b;
        input.push_back(P);
    }
    
    int x, y;
    
    scanf("%d %d", &x, &y);
    
    answers.push_back(x);
    answers.push_back(y);
    
    double thr;
    int q, alter;
    
    scanf("%lf %d %d", &thr, &q, &alter);
    
    vector<bool> res = readAnswers(input, answers, thr, q, alter);
    
    for (int i = 0; i < res.size(); i++)
    {
        if (res.at(i) == true)
        {
            printf("Questao %d: correta!\n", i);
        }
        else
        {
            printf("Questao %d: errada!\n", i);
        }
    }*/
    
    return 0;        
}
    
    

