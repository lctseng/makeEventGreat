#!/usr/bin/env python
# encoding=utf8
from bs4 import BeautifulSoup
import requests
import time
import sys

reload(sys)
sys.setdefaultencoding('utf8')

title = 'foo'
start_date = 'bar'
end_date = 'foo'
location = 'bar'
host = 'foo'
description = 'bar'
url = 'foo'
fee = 0
number_of_people = 0
source = 'bar'
img_url = 'foo'

idf = 1
iti = 0

firstI = 1

hasEm = False

jsonFile = open('events.json','w')
jsonFile.write('[')

#{"employees":[
#    {"firstName":"John", "lastName":"Doe"},
#    {"firstName":"Anna", "lastName":"Smith"},
#    {"firstName":"Peter", "lastName":"Jones"}
#]}

class TrmClr:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def crawlChildPage(inputUrl):
    response = requests.get(inputUrl)
    sourceCode = response.content.decode('utf-8')
    soup = BeautifulSoup(sourceCode, 'html.parser')

    positionIcon = soup.find('i',{'class':'fa-map-marker'})
    if positionIcon == None:
        global location
        location = '其他'
    else:
        location = positionIcon.parent.text
        location = location.replace('\\','\\\\').replace('"','\\"')
        #print(TrmClr.OKBLUE + '舉辦地點：' + location + TrmClr.ENDC)
    jsonFile.write('"location":"' + location + '",')

    if soup.find('span',{'class':'price'}) == None:
        fee = -1
    else:
        priceText = soup.find('span',{'class':'price'}).text
        if priceText == '免費':
            fee = 0
        else:
            fee = int(priceText[4:].replace(',','').replace('.',''))
        #print(TrmClr.HEADER + '價錢：' + str(fee) + TrmClr.ENDC)
        jsonFile.write('"fee":"' + str(fee) + '",')

    if soup.find('em') == None:
        global number_of_people
        number_of_people = -1
        jsonFile.write('"number_of_people":"' + str(number_of_people) + '",')
    else:
        allH2 = soup.findAll('h2')
        global hasEm
        hasEm = False
        for eachH2 in allH2:
            #print(eachH2)
            if eachH2.find('em') != None:
                #print('h2內有em')
                number_of_people = eachH2.find('em').text
                #print(TrmClr.OKBLUE + '報名人數：' + str(number_of_people) + TrmClr.ENDC)
                jsonFile.write('"number_of_people":"' + str(number_of_people) + '",')
                hasEm = True
                break
            else:
                #print('h2內沒em')
                number_of_people = -1
        if hasEm == False:
            #print('人數為-1')
            jsonFile.write('"number_of_people":"' + str(number_of_people) + '",')

def crawlSearchPage( inputUrl ):

    response = requests.get(inputUrl)
    sourceCode = response.content.decode('utf-8')
    # print(sourceCode)
    # got our source code !

    soup = BeautifulSoup(sourceCode, 'html.parser')
    eventListItems = soup.findAll('li', {'class': 'clearfix'})

    #print(eventListItems)

    if not eventListItems:
        return False

    global firstI
    if firstI != 1:
        jsonFile.write(',')
    firstI+=1

    global idf

    idf = 1

    for eachListItem in eventListItems:
        if idf != 1:
            jsonFile.write(',')
        idf+=1
        jsonFile.write('{')

        title = eachListItem.find('h2').find('a').text
        title = title.replace('"','\\"')
        #print(TrmClr.WARNING + '標題：' + title + TrmClr.ENDC)
        jsonFile.write('"title":"'+title+'",')

        dateText = eachListItem.find('div',{'class':'date'}).text
        start_date = dateText
        end_date = start_date
        global iti
        iti = 1
        for eachChar in dateText:
            if eachChar == '(':
                start_date = dateText[:iti-1]
                end_date = start_date
                break
            #print(eachChar)
            iti+=1
        #print( TrmClr.OKBLUE + '日期：' + start_date + TrmClr.ENDC )
        jsonFile.write('"start_date":"' + start_date + '",')
        jsonFile.write('"end_date":"' + end_date + '",')

        eventUrl = eachListItem.find('a', 'btn-small')['href']
        eventUrl = eventUrl.replace('"','\\"')
        #print( TrmClr.HEADER + '活動連結：' + eventUrl + TrmClr.ENDC )
        jsonFile.write('"url":"' + eventUrl + '",')

        eventDescription = eachListItem.find('div' , {'class':'description'}).text
        eventDescription = eventDescription.replace('\\','\\\\').replace('"','\\"')
        if eventDescription == '':
            eventDescription = '無'
        #print( '活動介紹：\n' + TrmClr.UNDERLINE + eventDescription.replace('\n', ' ').replace('\r', '') +TrmClr.ENDC )
        jsonFile.write('"description":"' + eventDescription.replace('\n', ' ').replace('\r', '') + '",')

        #print(TrmClr.OKBLUE + '活動來源：KKTIX' + TrmClr.ENDC)
        jsonFile.write('"source":"' + 'KKTIX' + '",')

        host = eachListItem.find('div',{'class':'host'}).find('a').text
        host = host.replace('"','\\"')
        #print(TrmClr.HEADER + '主辦單位：' + host + TrmClr.ENDC)
        jsonFile.write('"host":"' + host + '",')

        crawlChildPage( eventUrl )

        img_url = eachListItem.find('a', {'class': 'img-wrapper'}).find('img')['src']
        img_url = img_url.replace('"','\\"')
        #print(TrmClr.HEADER + '圖片網址：' + img_url + TrmClr.ENDC)
        jsonFile.write('"image_url":"' + img_url + '"')
        #print('')

        jsonFile.write('}')



urlHead = 'https://kktix.com/events?page='
urlFoot = '&search=&start_at=2016%2F11%2F20&utf8=%E2%9C%93'

pageLimit = 50

for i in range(pageLimit):

    #print('第'+str(i+1)+'頁')

    #print('使用網址：' + urlHead + str(i + 1) + urlFoot)
    if crawlSearchPage(urlHead+str(i + 1)+urlFoot) == False:
        #print('全部頁面爬完了，最後一頁為'+str(i))
        break

    time.sleep(0)

jsonFile.write(']')
jsonFile.close()

jsonFileOpen = open('events.json','r')
jsonContent = jsonFileOpen.read()
print(jsonContent)

