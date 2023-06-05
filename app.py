import pickle
from flask import Flask, render_template, request

app = Flask(__name__)

# File path to store the links
links_file = 'links.pkl'

# Load existing links from file, if any
try:
    with open(links_file, 'rb') as f:
        links = pickle.load(f)
except FileNotFoundError:
    links = []


def reverse_list(list):
    list.reverse()
    return list


@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        link = request.form.get('link')
        links.append(link)

        # Save the updated links to file
        with open(links_file, 'wb') as f:
            pickle.dump(links, f)

    return render_template('index.html', links=reverse_list(links))


if __name__ == '__main__':
    app.run()
