window.APP = {
    template: '#app_template',
    name: 'app',
    data() {
        return {
            cards: [
            ],
            styles: null,
            displayOpenAnother: false,
            /* displayOpenInventory: false, */
            displayClose: false,
            remain: 0,
            isShow: false,
        };
    },
    destroyed() {
        window.removeEventListener('message', this.listener);
        window.removeEventListener('keyup', this.EVENT_KEYPRESS);
    },
    mounted() {
        this.listener = window.addEventListener('message', (event) => {
            const item = event.data || event.detail; //'detail' is for debuging via browsers
            if (this[item.type]) {
                this[item.type](item);
            }
        });
        window.addEventListener('keyup', this.EVENT_KEYPRESS);
    },
    methods: {
        AddCards({ card }) {
            this.cards.push(card);
        },
        ON_OPEN() {
            this.isShow = false;
            this.cards = [];
        },
        ON_ADD_CARDS(item) {
            this.cards = item.cards;
            if (item.remain > 0) {
                this.remain = item.remain;
                this.displayOpenAnother = true;
                this.displayClose = false;
            } else {
                this.displayClose = true;
            }
        },
        ON_CLOSE() {
            this.cards = [];
        },
        ON_SHOW_CARD(item) {
            this.isShow = true;
            this.cards = [item.card];
        },
        SHOW_OPEN_ANOTHER(show) {
            this.displayOpenAnother = show;
        },
        SHOW_CLOSE(show) {
            this.displayClose = show;
        },

        EVENT_KEYPRESS(event) {
            if (this.isShow) {
                if (event.which == 27) {
                    $('#container-kartu').fadeOut(0);
                    $.post(`https://${GetParentResourceName()}/escape`, JSON.stringify({}));
                    this.displayClose = false;
                    this.displayOpenAnother = false;
                }
            }
        },

        /* Method Button */
        openAnother: function (event) {
            $('#container-kartu').fadeOut(0);
            $.post(`https://${GetParentResourceName()}/openAnother`, JSON.stringify({ remain: this.remain }));
            this.displayClose = false;
            /* this.displayOpenInventory = false; */
            this.displayOpenAnother = false;
        },
        close: function (e) {
            $('#container-kartu').fadeOut(0);
            $.post(`https://${GetParentResourceName()}/escape`, JSON.stringify({}));
            this.displayClose = false;
            this.displayOpenAnother = false;
        }
    },
};
