#include <Rcpp.h>
#include <stdlib.h>
#include <iostream>
#include <map>
#include <string>
#include <utility>

using namespace Rcpp;

typedef std::vector<std::string> strings;
typedef std::map<std::string, strings > NGramMap;

// this constructs a map of every word in the corpus to every word that could follow it
NGramMap buildMarkovChain(strings v)
{
  NGramMap grams;
  for (int i = 0; i < v.size() - 1; i++)
  {
    std::string current = v[i];
    std::string next = v[i + 1];
    if (grams.count(current) == 0) // if the current word is not yet in the map
    {
      strings next_word;
      next_word.push_back(next);
      grams.insert(std::make_pair(current, next_word));
    }
    else
    {
      grams[current].push_back(next);
    }

  }

  return grams;
}

strings predict_helper(strings c, int n, NGramMap m)
{
   if (n == 0)
    return c;
   else
   {

     std::string current = c.at(c.size() - 1);

       int index = std::rand() % m[current].size();
       std::string next = m[current].at(index);
       if (next == "+") // if a line is over, the function will stop recursing and return the current line.
       {
         c.erase(c.begin()); // to remove the @ marker
         return c;
       }
       c.push_back(next);

       return predict_helper(c, n - 1, m);


   }
}

strings predictMC(strings c, std::string s, int n) //arguments:  corpus, starting string, number of strings to predict
{
  NGramMap grams = buildMarkovChain(c);
  strings starting_point;
  starting_point.push_back(s);
  return predict_helper(starting_point, n, grams);
}

// [[Rcpp::export]]
void runMain(strings speakers, strings ccorpus, strings bcorpus)
{
  strings line_labels = predictMC(speakers, "Background", 30);
  for (int i = 0; i < line_labels.size();i++)
  {
    strings words;
    if (line_labels.at(i) == "Character") words = predictMC(ccorpus, "@", 100);
    else words = predictMC(bcorpus, "@", 100);

    std::cout << line_labels.at(i) << ":\t";
    for (int j = 0; j < words.size(); j++)
    {
      std::cout << words.at(j) << " ";
    }

    std::cout << std::endl;
  }
}
